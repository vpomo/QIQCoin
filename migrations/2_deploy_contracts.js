const QIQCrowdsale = artifacts.require('./QIQCrowdsale.sol');

module.exports = (deployer) => {
    //http://www.onlineconversion.com/unix_time.htm

    var startTimePreICO = 1517446800; //10 Feb 2018, 08:00:00 GMT
    var endTimePreICO = 1517446800; //18 Feb 2018, 08:00:00 GMT

    var startTimeICO = 1517446800; //18 Feb 2018, 08:01:00 GMT
    var endTimeICO = 1517446800; //30 Mar 2018, 08:00:00 GMT

    var owner = "0x250565aBd53EfeF39c8619b98c2420b85228474C";
    var wallet = "0x4524f69893550b38d29A853c7E1c313bcB651535";

    deployer.deploy(QIQCrowdsale, startTime, owner, wallet);

};
