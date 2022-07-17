import _ from "lodash";

function logicalId(state) {
  _.set(
    state,
    "userPool.name",
    [state.project, state.stage, "user", "pool"].join("-")
  );
  _.set(
    state,
    "userPool.id",
    state.userPool.name.replace(/[^a-z0-9]/gi, "").toUpperCase()
  );
  return state;
}

function reference(state) {
  _.set(state, "userPool.ref", { Ref: state.userPool.id });
  return state;
}

function resource(state) {
  logicalId(state);
  reference(state);
  _.set(state.resources, state.userPool.id, {
    Type: "AWS::Cognito::UserPool",
    Properties: {
      UserPoolName: state.userPool.name,
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
  });
  return state;
}

export default {
  logicalId,
  reference,
  resource,
};
