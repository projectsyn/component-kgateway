// main template for kgateway
local com = import 'lib/commodore.libjsonnet';
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local lib = import 'lib/kgateway.libsonnet';
local inv = kap.inventory();
// The hiera parameters for the component
local params = inv.parameters.kgateway;

local aggregatedClusterRole = {
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRole',
  metadata: {
    labels: {
      'rbac.authorization.k8s.io/aggregate-to-cluster-reader': 'true',
    },
    name: 'kgateway-crds-cluster-reader',
  },
  rules: [
    {
      apiGroups: [lib.kgatewayApiGroup],
      resources: ['*'],
      verbs: ['get', 'list', 'watch'],
    },
  ],
};

local gateways = com.generateResources(params.gateways, lib.Gateway);
local referenceGrants = com.generateResources(params.reference_grants, lib.ReferenceGrant);
local gatewayParameters = com.generateResources(params.gateway_parameters, lib.GatewayParameters);
local listenerPolicies = com.generateResources(params.listener_policies, lib.ListenerPolicy);
local backendConfigPolicies = com.generateResources(params.backend_config_policies, lib.BackendConfigPolicy);
local gatewayExtensions = com.generateResources(params.gateway_extensions, lib.GatewayExtension);
local trafficPolicies = com.generateResources(params.traffic_policies, lib.TrafficPolicy);
local httpRoutes = com.generateResources(params.http_routes, lib.HTTPRoute);

// Define outputs below
{
  '00_namespace': kube.Namespace(params.namespace) {
    metadata+: {
      annotations+: params.namespace_annotations,
      labels+: params.namespace_labels,
    },
  },
  [if params.rbac.aggregated_cluster_reader then '10_cluster_role']:
    aggregatedClusterRole,
} + {
  ['10_gateway_%s' % res.metadata.name]: res
  for res in gateways
} + {
  ['10_reference_grant_%s' % res.metadata.name]: res
  for res in referenceGrants
} + {
  ['10_gateway_parameters_%s' % res.metadata.name]: res
  for res in gatewayParameters
} + {
  ['10_listener_policy_%s' % res.metadata.name]: res
  for res in listenerPolicies
} + {
  ['10_backend_config_policy_%s' % res.metadata.name]: res
  for res in backendConfigPolicies
} + {
  ['10_gateway_extension_%s' % res.metadata.name]: res
  for res in gatewayExtensions
} + {
  ['10_traffic_policy_%s' % res.metadata.name]: res
  for res in trafficPolicies
} + {
  ['10_http_route_%s' % res.metadata.name]: res
  for res in httpRoutes
}
