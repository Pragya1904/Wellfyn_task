class MutualFund {
  late Meta meta;
  late List<Data> data;
  late String status;

  MutualFund({required this.meta, required this.data, required this.status});

  MutualFund.fromJson(Map<String, dynamic> json) {
    meta = (json['meta'] != null ? new Meta.fromJson(json['meta']) : null)!;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    status = json['status'];
  }
}

class Meta {
  String fundHouse="HDFC Mutual Fund";
  String schemeType="Open Ended Schemes";
  String schemeCategory="Other Scheme - Index Funds";
  int schemeCode=119063;
  String schemeName="HDFC Index Fund-NIFTY 50 Plan - Direct Plan";

  Meta(
      {required this.fundHouse,
        required this.schemeType,
        required this.schemeCategory,
        required this.schemeCode,
        required this.schemeName});

  Meta.fromJson(Map<String, dynamic> json) {
    fundHouse = json['fund_house'];
    schemeType = json['scheme_type'];
    schemeCategory = json['scheme_category'];
    schemeCode = json['scheme_code'];
    schemeName = json['scheme_name'];
  }
}

class Data {
  String date=DateTime.now().toString();
  String nav="not available currently";

  Data({required this.date, required this.nav});

  Data.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    nav = json['nav'];
  }
}
