/**
 * Library with public helper methods provided by component kgateway.
 */

local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();

local gw =
  if std.member(inv.applications, 'gateway-api') then
    import 'lib/gateway-api.libsonnet'
  else
    error 'Application "gateway-api" is required for the Gateway API helpers provided by lib/kgateway.libsonnet';

local kgatewayApiGroup = 'gateway.kgateway.dev';

local GatewayParameters(name='') = {
  apiVersion: '%s/v1alpha1' % kgatewayApiGroup,
  kind: 'GatewayParameters',
  metadata: {
    name: name,
  },
};

local ListenerPolicy(name='') = {
  apiVersion: '%s/v1alpha1' % kgatewayApiGroup,
  kind: 'ListenerPolicy',
  metadata: {
    name: name,
  },
};

local BackendConfigPolicy(name='') = {
  apiVersion: '%s/v1alpha1' % kgatewayApiGroup,
  kind: 'BackendConfigPolicy',
  metadata: {
    name: name,
  },
};

local GatewayExtension(name='') = {
  apiVersion: '%s/v1alpha1' % kgatewayApiGroup,
  kind: 'GatewayExtension',
  metadata: {
    name: name,
  },
};

local TrafficPolicy(name='') = {
  apiVersion: '%s/v1alpha1' % kgatewayApiGroup,
  kind: 'TrafficPolicy',
  metadata: {
    name: name,
  },
};

{
  Gateway: gw.Gateway,
  HTTPRoute: gw.HTTPRoute,
  ReferenceGrant: gw.ReferenceGrant,

  GatewayParameters: GatewayParameters,
  ListenerPolicy: ListenerPolicy,
  BackendConfigPolicy: BackendConfigPolicy,
  GatewayExtension: GatewayExtension,
  TrafficPolicy: TrafficPolicy,

  gatewayApiGroup: gw.gatewayApiGroup,
  gatewayApiExperimentalGroup: gw.gatewayApiExperimentalGroup,
  kgatewayApiGroup: kgatewayApiGroup,
}
