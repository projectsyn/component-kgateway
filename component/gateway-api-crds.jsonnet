// Gateway API CRDs and RBAC
local kap = import 'lib/kapitan.libjsonnet';
local lib = import 'lib/kgateway.libsonnet';
local inv = kap.inventory();
local params = inv.parameters.kgateway;

local gateway_crds =
  local manifests_dir = '%s/manifests/gateway-api' % inv.parameters._base_directory;
  std.flatMap(
    function(file)
      std.parseJson(kap.yaml_load_stream('%s/%s' % [manifests_dir, file])),
    kap.dir_files_list(manifests_dir)
  );

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
      apiGroups: [lib.gatewayApiGroup],
      resources: ['*'],
      verbs: ['get', 'list', 'watch'],
    },
  ],
};

if params.gateway_api.enabled then
  {
    ['01_gateway_api_crds/' + crd.metadata.name]: crd
    for crd in gateway_crds
  } + {
    [if params.rbac.aggregated_cluster_reader then '10_gateway_api_cluster_role']:
      aggregatedGatewayApiClusterRole,
  }
else
  {}
