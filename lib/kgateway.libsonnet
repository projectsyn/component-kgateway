/**
 * Library with public helper methods provided by component kgateway.
 */

local gatewayApiGroup = 'gateway.networking.k8s.io';
local kgatewayApiGroup = 'gateway.kgateway.dev';

local Gateway(name='') = {
  apiVersion: '%s/v1' % gatewayApiGroup,
  kind: 'Gateway',
  metadata: {
    name: name,
  },
};

local ReferenceGrant(name='') = {
  apiVersion: '%s/v1beta1' % gatewayApiGroup,
  kind: 'ReferenceGrant',
  metadata: {
    name: name,
  },
};

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
  Gateway: Gateway,
  ReferenceGrant: ReferenceGrant,
  GatewayParameters: GatewayParameters,
  ListenerPolicy: ListenerPolicy,
  BackendConfigPolicy: BackendConfigPolicy,
  GatewayExtension: GatewayExtension,
  TrafficPolicy: TrafficPolicy,

  gatewayApiGroup: gatewayApiGroup,
  kgatewayApiGroup: kgatewayApiGroup,
}
