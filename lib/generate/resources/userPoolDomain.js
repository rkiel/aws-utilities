function logicalId(Name) {
  return "USERPOOLDOMAIN" + Name.replace(/[^a-z0-9]/gi, "").toUpperCase();
}

function reference(Name) {
  return { Ref: logicalId(Name) };
}

function resource(Domain, Name, UserPoolId) {
  return {
    [logicalId(Name)]: {
      Type: "AWS::Cognito::UserPoolDomain",
      Properties: {
        Domain,
        UserPoolId,
      },
    },
  };
}

export default {
  logicalId,
  reference,
  resource,
};
