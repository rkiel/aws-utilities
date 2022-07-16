function logicalId(Name) {
  return "USERPOOLCLIENT" + Name.replace(/[^a-z0-9]/gi, "").toUpperCase();
}

function reference(Name) {
  return { Ref: logicalId(Name) };
}

function resource(Name, CallbackURLs, LogoutURLs, userPoolReference) {
  return {
    [logicalId(Name)]: {
      Type: "AWS::Cognito::UserPoolClient",
      Properties: {
        UserPoolId: userPoolReference,
        AllowedOAuthFlowsUserPoolClient: true,
        CallbackURLs,
        LogoutURLs,
        AllowedOAuthFlows: ["code", "implicit"],
        AllowedOAuthScopes: ["phone", "email", "openid", "profile"],
        SupportedIdentityProviders: ["COGNITO"],
      },
    },
  };
}

export default {
  logicalId,
  reference,
  resource,
};
