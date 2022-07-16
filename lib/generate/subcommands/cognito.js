function userPool(Name) {
  return {
    ["USERPOOL" + Name.replace(/[^a-z0-9]/gi, "").toUpperCase()]: {
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

cf.Resources = Object.assign({}, userPool("Test-2022-07-16"));

export function cognito(x) {
  console.log(JSON.stringify(cf, null, 2));
}
