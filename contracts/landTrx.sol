pragma solidity 0.5.0;
pragma experimental ABIEncoderV2;
import "./oraclizeAPI.sol";

contract deal{
        uint public value;
        address payable public seller;
        address payable public buyer;
        uint public landID;


        constructor(uint _landID, address payable _buyer , uint _price) public  {
            value = _price;
            seller = tx.origin;
            buyer = _buyer;
            landID = _landID;

        }

        function buy(address payable _seller) public payable returns (bool status){
            require(msg.value == value,"not equal amount");
            require(buyer == tx.origin, "you are not authorised");

            // require(seller.call.value(msg.value).gas(2000000)(),"transfer failed");

            _seller.transfer(msg.value);
            _seller.transfer(address(this).balance);
            return true;
        }

}



contract landTrx  is usingOraclize {
    address registryOffice;
    // address[] public contracts;
    mapping (address => deal) public contracts;
    uint public value ;
    string re;
    struct point{
        string latitude;
        string longitude;
        bool active;
    }

    
    struct landRecord{
        uint noOfVertices;
        point[12] vertices;
    }

    landRecord tempLandRecord;
    string public tempStr;
    //uint v;
    uint public landCount;
    mapping (uint => landRecord) public landRecords;
    mapping (address => uint) public owns;
    mapping (uint => address) public ownedby;
    
    event LogResultPossible(
        string re
    );
    event LogNewOraclizeQuery( string s);


    // modifier onlyBefore(string storage s) {require( 0 != temp.length );_;}

    constructor() public{
        OAR = OraclizeAddrResolverI(0xeD75eC1cDB1159C3Aa99Ef68Ef8b4082EF94978c);
        registryOffice = msg.sender;

        //v= 12413142;
        point memory p;
        // p.latitude = 28189089;
        // p.longitude = 76625366;
        // uint len = landRecords[registryOffice].len();
        // tempLandRecord = landRecord(1,[p]);
        landCount=2;
        landRecords[1] = tempLandRecord;
        // uint l = landRecords[owns[registryOffice]].length;

        p.latitude = "28189089";
        p.longitude = "76625366";
        p.active = true;
       
        landRecords[1].vertices[0] = p;
        // landRecords[registryOffice][l-1].v1 = p;
        p.latitude = "28189099";
        p.longitude = "76625396";
        
        landRecords[1].vertices[1] = p;
        // landRecords[registryOffice][l-1].v2 = p;
        p.latitude = "28189189";
        p.longitude = "76624666";
        
        landRecords[1].vertices[2] = p;
        // landRecords[registryOffice][l-1].v3 = p;
        p.latitude = "28189689";
        p.longitude = "76621866";
        
        landRecords[1].vertices[3] = p;
        // landRecords[registryOffice][l-1].v4 = p;
       
        
        landRecords[1].noOfVertices = 4;
        owns[registryOffice]=1;
        ownedby[1]=registryOffice;

        // tempStr = p.latitude;
        
        // tempStr  = append("Asd","asdsa","sadas");
        // tempStr = "ASda";
        // landTransfer(tempStr);

        
    }
    
    function landAssignment(address _owner, uint _n, string[] memory _vertices) public {
        
        require(msg.sender==registryOffice,"Only registry Office can create new land records");
        point memory p;
        landRecords[landCount] = tempLandRecord;
        // uint l = landRecords[_owner].length;

        for( uint i=0;i<2*_n;i=i+2){
         p.latitude = _vertices[i];
         p.longitude = _vertices[i+1];
         p.active = true;
         landRecords[landCount].vertices[i/2] = p; 
        }
        landRecords[landCount].noOfVertices = _n;
        owns[_owner] = landCount;
        ownedby[landCount] = _owner;
        landCount++;

        
       
        // landRecords[registryOffice][l-1].vertices[0] = p;
        // landRecords[registryOffice][l-1].v1 = p;
        
        
        
    }
     function __callback(
        bytes32 _myid,
        string memory _result
    )
        public
    {
        require(msg.sender == oraclize_cbAddress());
        re = _result;
        emit LogResultPossible(_result);


        // Do something with viewsCount, like tipping the author if viewsCount > X?
    }
    

    function landTransfer(address _newOwner) public payable{
        emit LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer...");
        // string storage st = landRecords[msg.sender][0].v1.latitude;


        // string memory u = append3("json(https://tough-bobcat-94.localtunnel.me/my-route?page=", _st, ").a");
        // oraclize_query("URL", u);
        
    }

    function sellLand(address payable _buyer , uint _price) public payable{
        require(owns[msg.sender] != 0, "you own nothing");
        contracts[msg.sender] = new deal(owns[msg.sender],_buyer ,_price);
        // contracts[msg.sender]    = address(d);
        
    }

    function buyLand(address payable _seller) public payable{
        // value = contracts[_seller].value();
         contracts[_seller].buy.value(msg.value)(_seller);

         _seller.transfer(address(this).balance);
         owns[msg.sender] = owns[_seller];
         owns[_seller] = 0;
         ownedby[owns[msg.sender]] = msg.sender;


    }



    function getRecord(address _owner) public returns(point[12] memory r){
        return(landRecords[owns[_owner]].vertices);
        
    }

    function getTemp() public returns(string memory st){
        return(tempStr);
        
    }

    function append3(string memory a, string memory b, string memory c) internal pure returns (string memory) {

    return string(abi.encodePacked(a, b, c));
    }
    function append4(string memory a, string memory b, string memory c, string memory d) internal pure returns (string memory) {

    return string(abi.encodePacked(a, b, c, d));

}
    
    
}
