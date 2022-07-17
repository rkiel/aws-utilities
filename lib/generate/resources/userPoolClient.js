import _ from "lodash";
function logicalId(state) {
  _.set(
    state,
    "userPoolClient.name",
    [state.project, state.stage, "user", "pool", "client"].join("-")
  );
  _.set(
    state,
    "userPoolClient.id",
    state.userPoolClient.name.replace(/[^a-z0-9]/gi, "").toUpperCase()
  );
  return state;
}

function reference(state) {
  _.set(state, "userPoolClient.ref", { Ref: state.userPoolClient.id });
  return state;
}

function resource(state) {
  logicalId(state);
  reference(state);
  _.set(state.resources, state.userPoolClient.id, {
    Type: "AWS::Cognito::UserPoolClient",
    Properties: {
      UserPoolId: state.userPool.ref,
      AllowedOAuthFlowsUserPoolClient: true,
      CallbackURLs: state.userPoolClient.CallbackURLs,
      LogoutURLs: state.userPoolClient.LogoutURLs,
      AllowedOAuthFlows: ["code", "implicit"],
      AllowedOAuthScopes: ["phone", "email", "openid", "profile"],
      SupportedIdentityProviders: ["COGNITO"],
    },
  });
  return state;
}

export default {
  logicalId,
  reference,
  resource,
};
