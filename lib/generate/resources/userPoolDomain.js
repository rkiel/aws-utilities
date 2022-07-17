import _ from "lodash";

function logicalId(state) {
  _.set(
    state,
    "userPoolDomain.name",
    [state.project, state.stage, "user", "pool", "domain"].join("-")
  );
  _.set(
    state,
    "userPoolDomain.id",
    state.userPoolDomain.name.replace(/[^a-z0-9]/gi, "").toUpperCase()
  );
  return state;
}

function reference(state) {
  _.set(state, "userPoolDomain.ref", { Ref: state.userPoolDomain.id });
  return state;
}

function resource(state) {
  logicalId(state);
  reference(state);
  _.set(state.resources, state.userPoolDomain.id, {
    Type: "AWS::Cognito::UserPoolDomain",
    Properties: {
      Domain: state.userPoolDomain.domain,
      UserPoolId: state.userPool.ref,
    },
  });
  return state;
}

export default {
  logicalId,
  reference,
  resource,
};
