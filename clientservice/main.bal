import ballerina/io;

public function main() returns error? {
    Client httpClient = check new ();

    // GET LECTURERS
    foreach var l in check httpClient->/lecturers {
        io:println(l);
    }

    // ADD LECTURERS
    _ = check httpClient->/newlecturer.post({full_name: "Steven Tjiraso",office_number: "Office1",staff_number: "1",list_of_courses: ["DSA", "PRG"]});


    // GET LECTURER BY STAFF NUMBER
    var lecturer = check httpClient->/lecturerbystaffnumber/["1"];
    io:println(lecturer.toString());


    // GET LECTURERS BY OFFICE NUMBER
    var lecturers = check httpClient->/lecturersbyofficenumber/["Office1"];
    io:println(lecturers.toString());


    // GET LECTURERS BY COURSE CODE
    var lecturerscc = check httpClient->/lecturersbycoursecode/["PRG"];
    io:println(lecturerscc.toString());


    // UPDATE LECTURER
    Lecturer update = {full_name: "Steven Tjiraso",office_number: "Office51",staff_number: "1",list_of_courses: ["DSA", "PRG", "ICG"]};
    _ = check httpClient->/updatelecturerdetails.put(update);


    // DELETE LECTURER
    var deleted = check httpClient->/deletelecturer/["1"].delete;
    io:println(deleted.toString());

}


