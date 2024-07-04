class PaymentMethod{
  final String title;
  final String imagepath;
  int  value;
  int? selectedRadio;

  PaymentMethod({
    required this.title,
    required this.imagepath,
   required this.value,
    this.selectedRadio = 0,
  });


}


final paymentMethodsList = [
  PaymentMethod(title: "Credit Card",imagepath: "assets/images/master.png", value: 0,),
  PaymentMethod(title: "Paypal",imagepath: "assets/images/paypal.png", value: 1,),
  PaymentMethod(title: "Apple Pay",imagepath: "assets/images/apple_pay.png", value: 2,),

];




