#!/usr/bin/env bash

_consul="/usr/local/bin/consul";

if ! [ -f "${_consul}" ];
then
  exit 2;
fi;

if [ "${1}" ] && [ "${2}" ] && [ "${3}" ] && [ "${4}" ] && [ "${5}" ] && [ "${6}" ] && [ "${7}" ];
then
  master_name="${1}";
  role="${2}";
  state="${3}";
  from_ip="${4}";
  from_port="${5}";
  to_ip="${6}";
  to_port="${7}";
else
  exit 2;
fi;

consul_kv_put() {
  local key="${1}";
  local value="${2}";
  ${_consul} kv put "${key}" "${value}" >/dev/null;
  if [ "$?" -ne "0" ];
  then
    exit 1;
  fi;
};

if [ "${role}" = "leader" ];
then
  KVClusterMasterPrefix="redis/master";
  ClusterAlias="${master_name}";

  consul_kv_put "${KVClusterMasterPrefix}/${ClusterAlias}"          "${to_ip}:${to_port}";
  consul_kv_put "${KVClusterMasterPrefix}/${ClusterAlias}/hostname" "${to_ip}";
  consul_kv_put "${KVClusterMasterPrefix}/${ClusterAlias}/ipv4"     "${to_ip}";
  consul_kv_put "${KVClusterMasterPrefix}/${ClusterAlias}/ipv6"     "";
  consul_kv_put "${KVClusterMasterPrefix}/${ClusterAlias}/port"     "${to_port}";
fi;

exit 0;
