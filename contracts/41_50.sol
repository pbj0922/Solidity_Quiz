// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Quiz41{
    /*
    숫자만 들어갈 수 있으며 길이가 4인 배열을 (상태변수로)선언하고 그 배열에 숫자를 넣는 함수를 구현하세요. 
    배열을 초기화하는 함수도 구현하세요. (길이가 4가 되면 자동으로 초기화하는 기능은 굳이 구현하지 않아도 됩니다.)
    */
    uint[4] array;
    uint count;

    function setArray(uint n) public {
        array[count++] = n;
    }

    function getArray() public view returns(uint[4] memory) {
        return array;
    }

    function resetArray() public {
        for(uint i = 0; i < array.length; i++) {
            delete array[i];
        }
        count = 0;
    }
}

contract Quiz42{
    /*
    이름과 번호 그리고 지갑주소를 가진 '고객'이라는 구조체를 선언하세요. 
    새로운 고객 정보를 만들 수 있는 함수도 구현하되 이름의 글자가 최소 5글자가 되게 설정하세요.
    */
    struct guest{
        string name;
        uint number;
        address addr;
    }

    guest public Guest;

    function setGuest(string memory _name, uint _number) public {
        bytes memory nameToBytes = bytes(_name);
        require(nameToBytes.length > 4);
        Guest = guest(_name, _number, msg.sender);
    }
}

contract Quiz43{
    /*
    은행의 역할을 하는 contract를 만드려고 합니다. 별도의 고객 등록 과정은 없습니다. 
    해당 contract에 ether를 예치할 수 있는 기능을 만드세요. 
    또한, 자신이 현재 얼마를 예치했는지도 볼 수 있는 함수 그리고 자신이 예치한만큼의 ether를 인출할 수 있는 기능을 구현하세요.
    힌트 : mapping을 꼭 이용하세요.
    */

    mapping(address=>uint) bank;
    address owner = msg.sender;

    modifier isOwner {
        require(owner == msg.sender);
        _;
    }

    function deposit() public payable isOwner returns(uint) {
        bank[msg.sender] += msg.value;
        return msg.value;
    }

    function showMoney() public view isOwner returns(uint) {
        return bank[msg.sender];
    }

    function getMoney(uint a) public isOwner {
        a *= 10**18;
        bank[msg.sender] -= a;
        payable(owner).transfer(a);
    }
}

contract Quiz44{
    /*
    string만 들어가는 array를 만들되, 4글자 이상인 문자열만 들어갈 수 있게 구현하세요.
    */
    string[] array;

    function setArray(string memory a) public {
        bytes memory stringToBytes = bytes(a);
        require(stringToBytes.length >= 4);
        array.push(a);
    }

    function getArray() public view returns(string[] memory) {
        return array;
    }
}

contract Quiz45{
    /*
    숫자만 들어가는 array를 만들되, 100이하의 숫자만 들어갈 수 있게 구현하세요.
    */
    uint[] array;

    function setArray(uint n) public {
        require(n <= 100);
        array.push(n);
    }

    function getArray() public view returns(uint[] memory) {
        return array;
    }
}

contract Quiz46{
    /*
    3의 배수이거나 10의 배수이면서 50보다 작은 수만 들어갈 수 있는 array를 구현하세요.
    (예 : 15 -> 가능, 2의 배수 // 40 -> 가능, 10의 배수이면서 50보다 작음 // 66 -> 가능, 3의 배수 // 70 -> 불가능 10의 배수이지만 50보다 큼)
    */
    uint[] array;

    function setArray(uint n) public {
        require(n%3==0 || n%10==0 && n<50);
        array.push(n);
    }

    function getArray() public view returns(uint[] memory) {
        return array;
    }
}

contract Quiz47{
    /*
    배포와 함께 배포자가 owner로 설정되게 하세요. owner를 바꿀 수 있는 함수도 구현하되 그 함수는 owner만 실행할 수 있게 해주세요.
    */

    address public owner = msg.sender;

    modifier isOwner {
        require(owner == msg.sender);
        _;
    }

    function changeOwner(address a) public isOwner {
        owner = a;
    }
}

contract Quiz48_A{
    /*
    A라는 contract에는 2개의 숫자를 더해주는 함수를 구현하세요. 
    B라고 하는 contract를 따로 만든 후에 A의 더하기 함수를 사용하는 코드를 구현하세요.
    */

    function add(uint a, uint b) public pure returns(uint) {
        return a+b;
    }
}

contract Quiz48_B {
    Quiz48_A A = new Quiz48_A();

    function addA(uint a, uint b) public view returns(uint) {
        return A.add(a,b);
    }
}

contract Quiz49{
    /*
    긴 숫자를 넣었을 때, 마지막 3개의 숫자만 반환하는 함수를 구현하세요.
    예) 459273 → 273 // 492871 → 871 // 92218 → 218
    */
    function getThreeNumber(uint _n) public pure returns(uint) {
        uint n = _n;
        uint count;
        while(n!=0) {
            n/=10;
            count++;
        }

        uint[] memory numberToArray = new uint[](count);
        n = _n;
        uint _count = count;
        while(n!=0) {
            numberToArray[--_count] = n%10;
            n/=10;
        }

        uint result;
        for(uint i = 0; i < 3; i++) {
            result += (numberToArray[--count] * 10**i); 
        }

        return result;
    }
}

contract Quiz50{
    /*
    숫자 3개가 부여되면 그 3개의 숫자를 이어붙여서 반환하는 함수를 구현하세요. 
    예) 3,1,6 → 316 // 1,9,3 → 193 // 0,1,5 → 15 
    응용 문제 : 3개 아닌 n개의 숫자 이어붙이기
    */

    function threeNumTogether(uint a, uint b, uint c) public pure returns(uint){
        require(a<10 && b<10 && c<10);

        uint result;
        result = (a * 10**2) + (b * 10) + c;

        return result;
    }
}