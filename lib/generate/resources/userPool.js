function logicalId(Name) {
  return "USERPOOL" + Name.replace(/[^a-z0-9]/gi, "").toUpperCase();
}

function reference(Name) {
  return { Ref: logicalId(Name) };
}

function resource(Name) {
  return {
    [logicalId(Name)]: {
      Type: "AWS::Cognito::UserPool",
      Properties: {
        UserPoolName: Name,
        Schema: [
          {
            AttributeDataType: String,
            Mutable: false,
            Name: "email",
            Required: true,
            //           NumberAttributeConstraints: NumberAttributeConstraints,
            //          DeveloperOnlyAttribute: Boolean,
            //            StringAttributeConstraints: StringAttributeConstraints,
          },
        ],
        AutoVerifiedAttributes: ["email"],
      },
    },
  };
}

export default {
  logicalId,
  reference,
  resource,
};
