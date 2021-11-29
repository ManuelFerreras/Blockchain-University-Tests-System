pragma solidity >= 0.8.0;
pragma experimental ABIEncoderV2;

// SPDX-License-Identifier: UNLICENSED

contract MarksContract {

    // Professor Address
    address public professor;

    // Constructor
    constructor () {
        professor = msg.sender;
    }

    // Realtes a mark with a student's hash.
    mapping (bytes32 => uint) marks;

    // Students which asked for revisions.
    string [] revisions;

    // Events
    event evaluatedStudent(bytes32, uint);
    event revisionEvent(string);

    // Evaluate a student.
    function evaluate(string memory _studentId, uint _mark) public onlyProfessor {
        
        // Convert student identity to a hash.
        bytes32 _studentIdAsHash = keccak256(abi.encodePacked(_studentId));

        // Relate student's hash to its mark.
        marks[_studentIdAsHash] = _mark;

        // Emit an event.
        emit evaluatedStudent(_studentIdAsHash, _mark);

    }

    // Check that the msg.sender is the professor.
    modifier onlyProfessor() {
        require(msg.sender == professor, "Only callable by professor.");
        _;
    }

    // See a student's mark.
    function getMark(string memory _studentId) public view returns (uint) {

        // Convert student's id to a hash.
        bytes32 _studentIdAsHash = keccak256(abi.encodePacked(_studentId));

        // Return Student's mark.
        return(marks[_studentIdAsHash]);

    } 

    // Ask for a revision.
    function askForRevision(string memory _studentId) public {

        // Store student's identity in an array.
        revisions.push(_studentId);

        // Emit revision event.
        emit revisionEvent(_studentId);

    }

    // Read students that have made a revision request.
    function getRevisions() public view onlyProfessor returns (string[] memory) {

        // Returns revisions array.
        return revisions;

    }

}