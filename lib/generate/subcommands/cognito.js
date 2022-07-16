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
    LogicalIdUserPool: {
      Type: "AWS::Cognito::UserPool",
      Properties: {
        UserPoolName: "Test-2022-07-16",
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
  },

  //   Outputs: {
  //     //   set of outputs
  //   },
};
export function cognito(x) {
  console.log("CloudFormation", JSON.stringify(cf, null, 2));
}
