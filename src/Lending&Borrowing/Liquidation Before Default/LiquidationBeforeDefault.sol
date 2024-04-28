// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

contract LiquidationBeforeDefault {
    uint256 public constant paymentDefaultDuration = 1 days;
    uint256 public loanCount;
    bool public constant ACCEPTED = true;

    struct Loan {
        uint256 amount;
        uint32 acceptedTimestamp;
        uint32 lastRepaidTimestamp;
        bool state;
    }

    mapping(uint256 => Loan) public loans;

    constructor() {}

    function createLoan(address borrower, uint256 amount, uint32 acceptedTimestamp, uint32 paymentCycleDuration)
        public
        returns (uint256)
    {
        Loan memory loan =
            Loan({amount: amount, acceptedTimestamp: acceptedTimestamp, lastRepaidTimestamp: 0, state: true});

        uint256 loanId = loanCount;
        loans[loanId] = loan;
        loanCount++;

        return loanId;
    }

    function acceptLoan(uint256 loanId) public {
        Loan storage loan = loans[loanId];
        require(loan.state == true, "Loan is not in pending state");

        loan.acceptedTimestamp = uint32(block.timestamp);
    }

    function lastRepaidTimestamp(Loan storage loan) internal view returns (uint32) {
        return loan.lastRepaidTimestamp == 0 ? loan.acceptedTimestamp : loan.lastRepaidTimestamp;
    }

    function canLiquidateLoan(uint256 loanId) public view returns (bool) {
        Loan storage loan = loans[loanId];

        // Make sure loan cannot be liquidated if it is not active
        if (loan.state != true) return false;

        return (uint32(block.timestamp) - lastRepaidTimestamp(loan) > paymentDefaultDuration);
    }
}
