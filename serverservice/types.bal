// done by in group 4 members

import ballerina/http;

public type NoContentInline_response_200 record {|
    *http:NoContent;
    Inline_response_200 body;
|};

public type BadRequestError record {|
    *http:BadRequest;
    Error body;
|};

public type InternalServerError record {|
    *http:InternalServerError;
    Error body;
|};

public type NotFoundError record {|
    *http:NotFound;
    Error body;
|};

public type Office record {
    # the office number that identifies the office
    readonly string office_number;
    # A list of staff numbers of all the lecturers that are accomodated by the office
    string[] list_of_staff_numbers;
};

public type Error record {
    "BadRequest"|"OperationSuccessful"|"NotFound"|"InternalError" 'type;
    string message;
};

public type Lecturer record {
    # uniquely identifies a lecturer
    readonly string staff_number;
    # first and last names of the student
    string full_name;
    # the number of the office they are located
    string office_number?;
    # A list of course codes that the lecturer teaches
    string[] list_of_courses;
};

public type Course record {
    # Course code of the course
    readonly string course_code;
    # Name of the course
    string course_name?;
    # NQF level of the course
    int nqf_level?;
};

public type Inline_response_201 record {
    # the staff_number of the registered lecturer
    string userid?;
};

public type Inline_response_200 Lecturer|Course;
