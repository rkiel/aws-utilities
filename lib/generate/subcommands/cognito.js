import userPool from "../resources/userPool.js";
import userPoolClient from "../resources/userPoolClient.js";
import userPoolDomain from "../resources/userPoolDomain.js";

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

const userPoolName = "Test-2022-07-16";
const domain = (userPoolName + "-bob").toLowerCase();

cf.Resources = Object.assign(
  {},
  userPool.resource(userPoolName),
  userPoolClient.resource(userPoolName, userPool.reference(userPoolName)),
  userPoolDomain.resource(
    domain,
    userPoolName,
    userPool.reference(userPoolName)
  )
);

export function cognito(x) {
  console.log(JSON.stringify(cf, null, 2));
}
