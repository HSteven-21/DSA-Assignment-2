import ballerina/graphql;
import ballerina/io;

type DepartmentObjectiveResponse record {|
    record {|anydata dt;|} data;
|};

public function main() returns error? {
    graphql:Client graphqlClient = check new ("localhost:2120/peformanceManagement");

    string doc = string `
    mutation addDepartmentObjective($id:String!,$name:String!,$kpi:Float!){
        addDepartmentObjective(newproduct:{id:$id,name:$name,kpi:$kpi})
    }`;

    DepartmentObjectiveResponse addDepartmentResponse = check graphqlClient->execute(doc, {"id": "sp", "name": "Student Performance", "kpi": 0});

    io:println("Response ", addDepartmentResponse);
}
