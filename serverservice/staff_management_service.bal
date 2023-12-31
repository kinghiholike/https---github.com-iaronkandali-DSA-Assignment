// done by in group 4 members

import ballerina/http;

listener http:Listener ep0 = new (8080, config = {host: "localhost"});

isolated service / on ep0 {
    private StaffRepository central_repo = new ();

    # Creates a new lecturer
    #
    # + payload - parameter description 
    # + return - returns can be any of following types
    # Inline_response_201 (successfull registration)
    # BadRequestError (Bad request. The request parameters are not valid.)
    # http:Response (Server encountered an error)
    resource function post newlecturer(@http:Payload Lecturer payload) returns Inline_response_201|BadRequestError|InternalServerError|http:Response {
        string result;
        lock{
            result = self.central_repo.setLecturer(payload.clone());
        }
        if(result is "badrequest"){
            return <BadRequestError>{body: {'type: "BadRequest", message: "Lecturer with specified staff_number already exists"}};
        }
        if (result is ""){
            return <InternalServerError>{ body: {'type: "InternalError", message: "The server encountered an error"}};
        }
        return <Inline_response_201>{ userid: payload.staff_number};
    }
    # Fetches all lecturers
    #
    # + return - returns can be any of following types
    # Lecturer[] (List of students)
    # NotFoundError (The specified resource was not found)
    # http:Response (Server encountered an error)
    resource function get lecturers() returns Lecturer[]|NotFoundError|http:Response {
        lock{
            return self.central_repo.getLecturers();
        }
    }
    # Updates an existing lecturer details
    #
    # + payload - parameter description 
    # + return - returns can be any of following types
    # Inline_response_200 (Operation was successful)
    # BadRequestError (Bad request. The request parameters are not valid.)
    # NotFoundError (The specified resource was not found)
    # http:Response (Server encountered an error)
    resource function put updatelecturerdetails(@http:Payload Lecturer payload) returns Inline_response_200|BadRequestError|NotFoundError|InternalServerError|http:Response {
        lock{
            Lecturer|error result = self.central_repo.updateLecturer(payload.clone());
            if(result is error){
                if(result.message() is "notfound"){
                    return <NotFoundError>{body: {'type: "NotFound", message: "Lecturer with specified staff number does not exist"}};
                }
            }
            if(result is Lecturer){
                return <Inline_response_200>result.clone();
            }
            return <InternalServerError>{ body: {'type: "InternalError", message: "The server encountered an error"}};
        }
    }
    # Server returns the lecturer with which the staff_number passed in identifies.
    #
    # + staff_number - unique identifier for a lecturer 
    # + return - returns can be any of following types
    # Lecturer (Operation successfull)
    # BadRequestError (Bad request. The request parameters are not valid.)
    # NotFoundError (The specified resource was not found)
    # http:Response (Server encountered an error)
    resource function get lecturerbystaffnumber/[string staff_number]() returns Lecturer|BadRequestError|NotFoundError|http:Response {
        lock{
            Lecturer|error result = self.central_repo.getLecturerByStaffNumber(staff_number);
            if(result is error){
                return <NotFoundError>{body: {'type: "NotFound", message: "Lecturer with specified staff number does not exist"}};
            }
            return result.clone();
        }
    }
    # Deletes an existing lecturer
    #
    # + staff_number - unique identifier for a lecturer 
    # + return - returns can be any of following types
    # NoContentInline_response_200 (Operation was successful)
    # BadRequestError (Bad request. The request parameters are not valid.)
    # NotFoundError (The specified resource was not found)
    # http:Response (Server encountered an error)
    resource function delete deletelecturer/[string staff_number]() returns anydata|http:Response|http:StatusCodeResponse|error {
        lock{
            Lecturer|error result = self.central_repo.deleteLecturer(staff_number);
            if(result is error){
                return <NotFoundError>{body: {'type: "NotFound", message: "Lecturer with specified staff number does not exist"}};
            }
            return <Inline_response_200>result.clone();
        }
    }
    # Server returns a list of all the lecturers that teach  the course identified by the passed in course code
    #
    # + course_code - unique identifier for a single course 
    # + return - returns can be any of following types
    # Lecturer[] (Successfully returned list of lecturers)
    # BadRequestError (Bad request. The request parameters are not valid.)
    # NotFoundError (The specified resource was not found)
    # http:Response (Server encountered an error)
    resource function get lecturersbycoursecode/[string course_code]() returns Lecturer[]|BadRequestError|NotFoundError|http:Response {
        lock{
            Lecturer[]|error result = self.central_repo.getLecturersByCourseCode(course_code);
            if(result is error){
                return <NotFoundError>{body: {'type: "NotFound", message: "Not Found"}};
            }
            return result.clone();
        }
    }
    # Server returns a list of all the lecturers that are located at the office identified by the passed in office number
    #
    # + office_number - unique identifier for a single office 
    # + return - returns can be any of following types
    # Lecturer[] (Successfully returned list of lecturers)
    # BadRequestError (Bad request. The request parameters are not valid.)
    # NotFoundError (The specified resource was not found)
    # http:Response (Server encountered an error)
    resource function get lecturersbyofficenumber/[string office_number]() returns Lecturer[]|BadRequestError|NotFoundError|http:Response {
        lock{
            Lecturer[]|error result = self.central_repo.getLecturersByOfficeNumber(office_number);
            if(result is error){
                return <NotFoundError>{body: {'type: "NotFound", message: "Not Found"}};
            }
            return result.clone();
        }
    }
}