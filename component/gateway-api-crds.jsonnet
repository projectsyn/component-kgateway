// Gateway API CRDs via kustomize
local com = import 'lib/commodore.libjsonnet';
local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.kgateway;

local crds = com.Kustomization(
  'https://github.com/kubernetes-sigs/gateway-api/config/crd/%s' % params.gateway_api.channel,
  params.gateway_api.version,
);

crds
