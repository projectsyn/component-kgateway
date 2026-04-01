// main template for kgateway
local com = import 'lib/commodore.libjsonnet';
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
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
      apiGroups: ['gateway.networking.k8s.io'],
      resources: ['*'],
      verbs: ['get', 'list', 'watch'],
    },
    {
      apiGroups: ['gateway.kgateway.dev'],
      resources: ['*'],
      verbs: ['get', 'list', 'watch'],
    },
  ],
};

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
  ['10_gateway_%s' % name]: {
    apiVersion: 'gateway.networking.k8s.io/v1',
    kind: 'Gateway',
    metadata+: {
      name: name,
      namespace: params.namespace,
    },
  } + com.makeMergeable(params.gateways[name])
  for name in std.objectFields(params.gateways)
} + {
  ['10_reference_grant_%s' % name]: {
    apiVersion: 'gateway.networking.k8s.io/v1beta1',
    kind: 'ReferenceGrant',
    metadata+: {
      name: name,
      namespace: params.namespace,
    },
  } + com.makeMergeable(params.reference_grants[name])
  for name in std.objectFields(params.reference_grants)
} + {
  ['10_gateway_parameters_%s' % name]: {
    apiVersion: 'gateway.kgateway.dev/v1alpha1',
    kind: 'GatewayParameters',
    metadata+: {
      name: name,
      namespace: params.namespace,
    },
  } + com.makeMergeable(params.gateway_parameters[name])
  for name in std.objectFields(params.gateway_parameters)
} + {
  ['10_listener_policy_%s' % name]: {
    apiVersion: 'gateway.kgateway.dev/v1alpha1',
    kind: 'ListenerPolicy',
    metadata+: {
      name: name,
      namespace: params.namespace,
    },
  } + com.makeMergeable(params.listener_policies[name])
  for name in std.objectFields(params.listener_policies)
} + {
  ['10_backend_config_policy_%s' % name]: {
    apiVersion: 'gateway.kgateway.dev/v1alpha1',
    kind: 'BackendConfigPolicy',
    metadata+: {
      name: name,
      namespace: params.namespace,
    },
  } + com.makeMergeable(params.backend_config_policies[name])
  for name in std.objectFields(params.backend_config_policies)
} + {
  ['10_gateway_extension_%s' % name]: {
    apiVersion: 'gateway.kgateway.dev/v1alpha1',
    kind: 'GatewayExtension',
    metadata+: {
      name: name,
      namespace: params.namespace,
    },
  } + com.makeMergeable(params.gateway_extensions[name])
  for name in std.objectFields(params.gateway_extensions)
} + {
  ['10_traffic_policy_%s' % name]: {
    apiVersion: 'gateway.kgateway.dev/v1alpha1',
    kind: 'TrafficPolicy',
    metadata+: {
      name: name,
      namespace: params.namespace,
    },
  } + com.makeMergeable(params.traffic_policies[name])
  for name in std.objectFields(params.traffic_policies)
}
