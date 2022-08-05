pragma solidity ^0.5.0;

contract SocialNetwork {
    string public name;

    uint256 public postCount = 0;
    mapping(uint256 => Post) public posts;
    struct Post {
        uint256 id;
        string content;
        uint256 tipAmount;
        address payable author;
    }

    event PostCreated(
        uint256 id,
        string content,
        uint256 tipAmount,
        address payable author
    );

    event PostTipped(
        uint256 id,
        string content,
        uint256 tipAmount,
        address author
    );

    constructor() public {
        name = "Sri Harsha Surapaneni";
    }

    function createPost(string memory _content) public {
        //Require valid content
        require(bytes(_content).length > 0);

        //Increment the post count
        postCount++;
        //Create the post
        posts[postCount] = Post(postCount, _content, 0, msg.sender);
        //Trigger Event
        emit PostCreated(postCount, _content, 0, msg.sender);
    }

    function tipPost(uint256 _id) public payable {
        //make sure the id is valid
        require(_id > 0 && _id <= postCount);
        //fetch the post
        Post memory _post = posts[_id];
        //fetch the author
        address payable _author = _post.author;
        //pay the author
        address(_author).transfer(msg.value);
        //increment the tip tipAmount
        //1 ether = 100000000000000000
        _post.tipAmount = _post.tipAmount + msg.value;
        //update the post
        posts[_id] = _post;
        //trigger an event
        emit PostTipped(postCount, _post.content, _post.tipAmount, _author);
    }
}
