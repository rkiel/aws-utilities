import _ from "lodash";

function name(state) {
  return _.set(
    state,
    "userPool.name",
    [state.project, state.stage, "user", "pool"].join("-")
  );
}

function logicalId(state) {
  return _.set(
    state,
    "userPool.id",
    state.userPool.name.replace(/[^a-z0-9]/gi, "").toUpperCase()
  );
}

function reference(state) {
  return _.set(state, "userPool.ref", { Ref: state.userPool.id });
}

function something(state) {
  return _.set(state, `resources.${state.userPool.id}`, {
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
}

function resource(state) {
  name(state);
  logicalId(state);
  reference(state);
  something(state);
  return state;
}

export default {
  logicalId,
  reference,
  resource,
};
