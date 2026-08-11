// Aggregated cluster role for Gateway API resources
local kap = import 'lib/kapitan.libjsonnet';
local lib = import 'lib/kgateway.libsonnet';
local inv = kap.inventory();
local params = inv.parameters.kgateway;

local aggregatedGatewayApiClusterRole = {
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRole',
  metadata: {
    labels: {
      'rbac.authorization.k8s.io/aggregate-to-cluster-reader': 'true',
    },
    name: 'gateway-api-crds-cluster-reader',
  },
  rules: [
    {
      apiGroups: [ lib.gatewayApiGroup, lib.gatewayApiExperimentalGroup ],
      resources: [ '*' ],
      verbs: [ 'get', 'list', 'watch' ],
    },
  ],
};

{
  [if params.rbac.aggregated_cluster_reader then '10_gateway_api_cluster_role']:
    aggregatedGatewayApiClusterRole,
}
