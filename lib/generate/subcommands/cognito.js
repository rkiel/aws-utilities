import userPool from "../resources/userPool.js";
import userPoolClient from "../resources/userPoolClient.js";
import userPoolDomain from "../resources/userPoolDomain.js";
import _ from "lodash";

const cf = {
  AWSTemplateFormatVersion: "2010-09-09",

  Description: "Create Cognito User Pool",

  //   Metadata: {
  //     //  template metadata
  //   },

  //   Parameters: {
  //     //  set of parameters
  //   },

  //   Rules: {
  //     //   set of rules
  //   },

  //   Mappings: {
  //     //   set of mappings
  //   },

  //   Conditions: {
  //     //  set of conditions
  //   },

  //   Transform: {
  //     //   set of transforms
  //   },

  Resources: {
    //   set of resources
  },

  //   Outputs: {
  //     //   set of outputs
  //   },
};

let state = {
  project: "mysampleapp",
  stage: "dev",
  resources: {},
  userPoolClient: {
    CallbackURLs: ["http://localhost:3000/signin"],
    LogoutURLs: ["http://localhost:3000/signout"],
  },
  userPoolDomain: {
    domain: "fadafadfadfadfdfa",
  },
};

function _reducer(state, object) {
  return object.resource(state);
}

state = _.reduce([userPool, userPoolClient, userPoolDomain], _reducer, state);

cf.Resources = state.resources;

export function cognito(x) {
  console.log(JSON.stringify(cf, null, 2));
}
