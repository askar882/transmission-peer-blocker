#!/bin/bash
#
# Block peers using Xunlei, BT players and unknown clients for transmission.
#
# Reference: [Transmission 屏蔽迅雷反吸血脚本](https://zhuanlan.zhihu.com/p/158711236)
#   Xunlei client identifiers: https://github.com/c0re100/qBittorrent-Enhanced-Edition/blob/v4_2_x/src/base/bittorrent/session.cpp#L2212
#   Transmission Blocklist: https://github.com/transmission/transmission/blob/master/libtransmission/blocklist.cc

readonly LOGGER_TAG='transmission-peer-blocker'
readonly ID_FILTER='\-\(\(XL\|SD\|XF\|QD\|BN\|DL\|TS\|LT\|SP\|DT\)\([0-9]\+\)\|\(UW\w\{4\}\)\)-\|Xunlei\|Unknown'
readonly IPSET='trans'
readonly IPSET6='trans6'


###################################################
# Main function. Block IPs matching specific clients.
# Globals:
#   ID_FILTER
#   IPSET
# Arguments:
#   None
# Outputs:
#   None
###################################################
function main() {
  log 'Start scanning peers for illegal clients.'
  peers_info="$(query_peers | grep "${ID_FILTER}")"
  if [[ -z "${peers_info}" ]]; then
    log 'No illegal clients found. Exit.'
    return
  fi
  # Initialize if IP set doesn't exist.
  ipset list "${IPSET}" >/dev/null 2>&1
  if [[ "$?" != "0" ]]; then
    init
  fi
  echo "${peers_info}" | while read info; do
    ip="$(echo "${info}" | cut -d' ' -f1)"
    block_ip "${ip}"
  done
  log 'Peer blocking done.'
}

#######################################################
# Query all peers for their IPs and client identifiers.
# Arguments:
#   None
# Outputs:
#   All peers' IPs and client identifiers.
#######################################################
function query_peers() {
  # `transmission-remote -t all -ip` writes in the following format for every torrent:
  ## Address                                   Flags         Done  Down    Up      Client
  ## 93.43.200.6                               TE            100.0    0.0     0.0  qBittorrent 4.3.8

  # Query IPs and client identifiers exluding blank lines and lines starting with 'Address'.
  result="$(transmission-remote -t all -ip | grep -v '^Address\|^$')"
  echo "${result}"
}

########################################################
# Add IP address to ipset. Works both for IPv4 and IPv6.
# Globals:
#   IPSET
#   IPSET6
# Arguments:
#   address
# Outputs:
#   None
########################################################
function block_ip() {
  local setname="${IPSET}"
  if [[ "$1" =~ ':' ]]; then
    setname="${IPSET6}"
  fi
  if [[ "$(ipset list ${setname})" =~ "$1" ]]; then
    log "Address '$1' is already in blacklist."
    return
  fi
  ipset add "${setname}" "$1"
  log "Added '$1' to blacklist."
}


########################################
# Log
# Globals:
#   LOGGER_TAG
# Arguments:
#   Message to be logged.
# Outputs:
#   None
########################################
function log() {
  logger -t "${LOGGER_TAG}" "$*"
}

######################################
# Initialize ipset and iptables rules.
# Globals:
#   IPSET
#   IPSET6
# Arguments:
#   None
# Outputs:
#   None
######################################
function init() {
  log 'Initializing IP set.'
  ipset create "${IPSET}" hash:ip
  ipset create "${IPSET6}" hash:ip family inet6
  iptables -I INPUT -m set --match-set "${IPSET}" src,dst -j DROP
  ip6tables -I INPUT -m set --match-set "${IPSET6}" src,dst -j DROP
}


main
