
class QueryMutation {
  String createProduct(String imageUrl, String description, String title,String price) {
    return """
     mutation{
  createProduct(imageUrl:"£$imageUrl",description:"$description",price:"$price",title:"$title"){
    id
    price
    title
    description
  }
}
    """;
  }
  String register(String username, String email, String password) {
    return """
      mutation{
      Register(email: "$email",username: "$username",password: "$password"){
        id
        username
        email
      }
    }
    """;
  }
}