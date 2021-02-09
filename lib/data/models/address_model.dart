class AddressModel{

  AddressModel();

  factory AddressModel.fromJson(){return AddressModel();}

  toMap()=>{};

  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    return (identical(this, other)||
            other is AddressModel);
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

}