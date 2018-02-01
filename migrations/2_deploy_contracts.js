const QIQCrowdsale = artifacts.require('./QIQCrowdsale.sol');

module.exports = (deployer) => {
    //http://www.onlineconversion.com/unix_time.htm

    var startTimePreICO =   1517446800; //10 Feb 2018, 08:00:00 GMT
    var endTimePreICO =     1517446800; //18 Feb 2018, 08:00:00 GMT

    var startTime1stICO =   1517446800; //18 Feb 2018, 08:01:00 GMT
    var endTime1stICO =     1517446800; //28 Feb 2018, 08:00:00 GMT
    var startTime2ndICO =   1517446800; //28 Feb 2018, 08:01:00 GMT
    var endTime2ndICO =     1517446800; //15 Mar 2018, 08:00:00 GMT
    var startTimeFinalICO = 1517446800; //15 Mar 2018, 08:01:00 GMT
    var endTimeFinalICO =   1517446800; //30 Mar 2018, 08:00:00 GMT

    var owner = "0x250565aBd53EfeF39c8619b98c2420b85228474C";
    var wallet = "0x4524f69893550b38d29A853c7E1c313bcB651535";

    deployer.deploy(QIQCrowdsale,
        startTimePreICO, endTimePreICO,
        startTime1stICO, endTime1stICO,
        startTime2ndICO, endTime2ndICO,
        startTimeFinalICO, endTimeFinalICO,
        owner, wallet);

};
