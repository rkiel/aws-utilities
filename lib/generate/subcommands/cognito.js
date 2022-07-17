import fs from "fs";
import _ from "lodash";

import userPool from "../resources/userPool.js";
import userPoolClient from "../resources/userPoolClient.js";
import userPoolDomain from "../resources/userPoolDomain.js";

function createCloudFormation(state) {
  return {
    AWSTemplateFormatVersion: "2010-09-09",

    Description: state.description,

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

    Resources: state.resources,

    //   Outputs: {
    //     //   set of outputs
    //   },
  };
}

function createState() {
  return {
    project: "mysampleapp",
    stage: "dev",
    description: "Create Cognito User Pool",
    resources: {},
    userPoolClient: {
      CallbackURLs: ["http://localhost:3000/signin"],
      LogoutURLs: ["http://localhost:3000/signout"],
    },
    userPoolDomain: {
      domain: "fadafadfadfadfdfa",
    },
  };
}

function _resourceReducer(state, object) {
  return object.resource(state);
}

function createResources(state) {
  return _.reduce(
    [userPool, userPoolClient, userPoolDomain],
    _resourceReducer,
    state
  );
}

function save(state) {
  const cf = createCloudFormation(state);
  const content = JSON.stringify(cf, null, 2);
  let fileName = [state.project, state.stage, "cloud", "formation"].join("-");
  fileName = [fileName, "json"].join(".");
  try {
    console.log("Writing", fileName);
    fs.writeFileSync(fileName, content);
  } catch (err) {
    console.error(err);
  }

  return state;
}
export function cognito(x) {
  let state = createState();
  state = createResources(state);
  save(state);
}
