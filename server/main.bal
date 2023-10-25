import ballerina/io;
import ballerina/graphql;
import ballerinax/mongodb;

type Hod record {
    string first_name;
    string last_name;
    string job_position;
    string role;
    string objective;
    string id;
};

type Supervisor record {
    string first_name;
    string last_name;
    string job_position;
    string role;
    string objective;
    string id;
};

type Employee record {
    string first_name;
    string last_name;
    string job_position;
    string role;
    string objective;
    string id;
    int kpi;
    int employee_score;
};

type Objective record {
    string id;
    string name;
    int kpi;
};

type UserDetails record {
    string username;
    string? password;
    boolean isAdmin;
};

type User record {
    string username;
    string password;
};

type updatedUser record {
    string username;
    string password;
};


type LoggedUserDetails record {|
    string username;
    boolean isAdmin;
|};
mongodb:ConnectionConfig mongoConfig = {
    connection: {
        host: "localhost",
        port: 27017,
        auth: {
            username: "",
            password: ""
        },
        options: {
            sslEnabled: false,
            serverSelectionTimeout: 5000
        }
    },
    databaseName: "mongodbVSCodePlaygroundDB"
};

mongodb:Client db = check new (mongoConfig);
configurable string hodCollection = "Hods";
configurable string supervisorCollection = "Supervisors";
configurable string employeeCollection = "Employees";
configurable string userCollection = "Users";
configurable string objectiveCollection = "Objectives";
configurable string databaseName = "peformance-management";

@graphql:ServiceConfig {
    graphiql: {
        enabled: true,
    // Path is optional, if not provided, it will be dafulted to `/graphiql`.
    path: "/peformance"
    }
}

service /peformanceManagementSystem on new graphql:Listener(2120) {

resource function get login(User user) returns LoggedUserDetails|error {
        stream<UserDetails, error?> usersDeatils = check db->find(userCollection, databaseName, {username: user.username, password: user.password}, {});

        UserDetails[] users = check from var userInfo in usersDeatils
            select userInfo;
        io:println("Users ", users);
        // If the user is found return a user or return a string user not found
        if users.length() > 0 {
            return {username: users[0].username, isAdmin: users[0].isAdmin};
        }
        return {
            username: "",
            isAdmin: false
        };
    }

// mutation
    remote function addDepartmentObjective(Objective newobjective) returns error|string {
        map<json> doc = <map<json>>newobjective.toJson();
        _ = check db->insert(doc, objectiveCollection, "");
        return string `${newobjective.name} added successfully`;
    }

 // mutation
    remote function deleteDepartmentObjective(string id) returns error|string {
        mongodb:Error|int deleteItem = db->delete(objectiveCollection, "", {id: id}, false);
        if deleteItem is mongodb:Error {
            return error("Failed to delete items");
        } else {
            if deleteItem > 0 {
                return string `${id} deleted successfully`;
            } else {
                return string `objective not found`;
            }
        }

    }

remote function addEmployeeKpi(Kpi newkpi) returns error|string {
        map<json> doc = <map<json>>newkpi.toJson();
        _ = check db->insert(doc, employeeCollection, "");
        return string `${newkpi.name} added successfully`;
    }

 remote function deleteEmployeeKpi(string objective) returns error|string {
        mongodb:Error|int deleteItem = db->delete(employeeCollection, "", {objective: objective}, false);
        if deleteItem is mongodb:Error {
            return error("Failed to delete items");
        } else {
            if deleteItem > 0 {
                return string `${objective} deleted successfully`;
            } else {
                return string `objective not found`;
            }
        }

    }

 remote function updateEmployeeKpi(Employee employee) returns error|string {

        map<json> newEmployeeDoc = <map<json>>{"$set": {"kpi": employee.kpi}};

        int updatedCount = check db->update(newEmployeeDoc, employeeCollection, "", {username: updatedUser.username}, true, false);
        io:println("Updated Count ", updatedCount);

        if updatedCount > 0 {
            return string `${updatedUser.username} password changed successfully`;
        }
        return "Failed to updated";
    }

remote function getEmployeeTotalScore(Kpi newkpi) returns error|string {
        map<json> doc = <map<json>>newkpi.toJson();
        _ = check db->insert(doc, employeeCollection, "");
        return string `${newkpi.name} added successfully`;
    }

 remote function updateEmployeeKpi(string kpi) returns error|string {
        mongodb:Error|int deleteItem = db->update(employeeCollection, "", {kpi: kpi}, false);
        if update is mongodb:Error {
            return error("Failed to update kpi");
        } else {
                return string `${kpi} updated successfully`;
            } 
        }

    }



 remote function deleteEmployeeKpi(int kpi) returns error|string {
        mongodb:Error|int deleteItem = db->delete(employeeCollection, "", {kpi: kpi}, false);
        if deleteItem is mongodb:Error {
            return error("Failed to delete kpi");
        } else {
            
                return string `${kpi} deleted successfully`;
            } 
        }
;
