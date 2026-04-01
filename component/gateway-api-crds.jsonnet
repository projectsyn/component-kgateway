// Gateway API CRDs via kustomize
local com = import 'lib/commodore.libjsonnet';
local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.kgateway;

local crdPath =
  if params.gateway_api.channel == 'standard' then
    'https://github.com/kubernetes-sigs/gateway-api/config/crd'
  else
    'https://github.com/kubernetes-sigs/gateway-api/config/crd/%s' % params.gateway_api.channel;

local crds = com.Kustomization(
  crdPath,
  params.gateway_api.version,
);

crds
