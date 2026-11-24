// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title REBELDE Token ($RBD)
 * @dev Contrato padrão BEP-20 para BNB Smart Chain (BSC).
 * Suprimento total: 9.000.000 REBELDE
 */
contract REBELDE {
    string public constant name = "REBELDE";
    string public constant symbol = "RBD";
    uint8 public constant decimals = 18;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "REBELDE: apenas o proprietario");
        _;
    }

    constructor() {
        owner = msg.sender;
        totalSupply = 9_000_000 * 10 ** uint256(decimals);
        balanceOf[owner] = totalSupply;
        emit Transfer(address(0), owner, totalSupply);
        emit OwnershipTransferred(address(0), owner);
    }

    function getOwner() external view returns (address) {
        return owner;
    }

    function transfer(address to, uint256 value) public returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0), "REBELDE: aprovacao para endereco zero");
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(allowance[from][msg.sender] >= value, "REBELDE: permissao insuficiente");
        allowance[from][msg.sender] -= value;
        _transfer(from, to, value);
        return true;
    }

    function burn(uint256 value) public returns (bool) {
        require(balanceOf[msg.sender] >= value, "REBELDE: saldo insuficiente para queima");
        balanceOf[msg.sender] -= value;
        totalSupply -= value;
        emit Transfer(msg.sender, address(0), value);
        return true;
    }

    function _transfer(address from, address to, uint256 value) internal {
        require(from != address(0), "REBELDE: transferencia do endereco zero");
        require(to != address(0), "REBELDE: transferencia para endereco zero");
        require(balanceOf[from] >= value, "REBELDE: saldo insuficiente");

        balanceOf[from] -= value;
        balanceOf[to] += value;
        emit Transfer(from, to, value);
    }

    // Função de segurança adicionada: permite abrir mão da propriedade do contrato
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(owner, address(0));
        owner = address(0);
    }
}
