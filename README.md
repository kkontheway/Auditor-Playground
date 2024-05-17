[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://raw.githubusercontent.com/kkontheway/IMG/main/202404191806005.png">
    <img src="https://raw.githubusercontent.com/kkontheway/IMG/main/202404191806005.png" alt="Logo" width="200" height="200">
  </a>

  <h3 align="center">Auditor-Playground</h3>

  <p align="center">
    An playground For Auditor.
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#Requirement">Requirement</a></li>
        <li><a href="#QuickStart">QuickStart</a></li>
      </ul>
    </li>
    <li><a href="#Test">Test</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

# Getting Start

## Requirement
- git
- foundry

## QuickStart
```
git clone https://github.com/kkontheway/Mini-Exploits-Playground.git
cd Auditor-Playground
forge install
```

## Test
```solidity
forge test
```

## Running a single test
```
forge test --mt test_functionName
```
## Roadmap

- [ ] Reentrancy
  - [x] Normal Reentrancy
  - [x] Readonly Reentrancy
  - [x] Cross Function Reentrancy
  - [x] Cross Contract Reentrancy
  - [ ] Cross Chain Reentrancy
- [x] Signature Reply
- [ ] ABI Collisions
- [ ] Over/Under Flow
- [ ] Oracle Manipulation
- [ ] Multi-language Support
- [ ] DDOS
  - [ ] uint-to-enum
- [x] Weak Randomness
- [ ] Missing Access Control
- [x] Proxy Attack
  - [x] Function Collision
  - [x] Storage Collision
  - [x] Uninitialized
  - [x] metamorphic_rug
  - [x] delegatecall_with_selfdestruct
- [ ] msg.value in a Loop
- [ ] Flashloan Attack
- [ ] Lending&Borrow Attack
- [ ] Precision Loss
  - [x] Division Before Multiplication
  - [x] Rounding Down To Zero
  - [x] Excessive Precision Scaling
  - [ ] Rounding Leaks Value Form Protocol
  - [x] No Precision Scaling
  - [ ] Mis matched Precision Scaling
- [ ] Mistake By Developer
  - [ ] Unexpected Empty Inputs
- [ ] Lending&Borrowing Attack
  - [x] LiquidateLoanBeforeFirstPayment
  - [x] Borrower Can not be Liquidate


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. 

Don't forget to give the project a star! Thanks again!
# Disclaimer

All code, practices, and patterns in this repository are used for educational purposes only.

!!! DO NOT USE IN PRODUCTION !!!

# Thank you!!!!

[contributors-shield]: https://img.shields.io/github/contributors/kkontheway/Mini-Exploits-Playground.svg?style=for-the-badge
[contributors-url]: https://github.com/kkontheway/Mini-Exploits-Playground/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/kkontheway/Mini-Exploits-Playground.svg?style=for-the-badge
[forks-url]: https://github.com/kkontheway/Mini-Exploits-Playground/network/members
[stars-shield]: https://img.shields.io/github/stars/kkontheway/Mini-Exploits-Playground.svg?style=for-the-badge
[stars-url]: https://github.com/kkontheway/Mini-Exploits-Playground/stargazers
[issues-shield]: https://img.shields.io/github/issues/kkontheway/Mini-Exploits-Playground.svg?style=for-the-badge
[issues-url]: https://github.com/kkontheway/Mini-Exploits-Playground/issues
[license-shield]: https://img.shields.io/github/license/kkontheway/Mini-Exploits-Playground.svg?style=for-the-badge
[license-url]: https://github.com/kkontheway/Mini-Exploits-Playground/LICENSE.txt


# Star History

[![Star History Chart](https://api.star-history.com/svg?repos=kkontheway/Auditor-Playground&type=Date)](https://star-history.com/#kkontheway/Auditor-Playground&Date)
