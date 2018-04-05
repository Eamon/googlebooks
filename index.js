/* This is an index file for a Google Cloud Functions program that accesses the Google Books API.

You will need a Google Cloud platform account and create a project which is authorized to access the Google Books API 
The Google Books API appears to have a limit of about 1,000 requests a day under the free tier 

*/

exports.getBook = function getBook (req, res){
 		 
 try{
	
	var apikey = "<<INSERT YOUR GOOGLE API KEY HERE>>";

	var util = require('util');
	var google = require('googleapis');
	var serviceAccount = require('./key.json'); //Auth details for your Google Cloud project

	var { client_email, private_key } = serviceAccount;
	var scope = ['https://www.googleapis.com/auth/books']
	var client = new google.auth.JWT(client_email, null, private_key, scope, null);
	var books = google.books({ version: 'v1', auth: client });

	 //Open a text file that contains a list of book details.
	//Each line of the file contains an author name book title and publisher as one string
	//Google can handle such fuzzy searches e.g. "James Joyce Ulysses Penguin Books"
  
	var fs = require('fs'); 
	var path = require('path');
	 
	var searchStrsFlLoc = path.join(__dirname, "booksAsStrs.txt")
	var searchStrs = fs.readFileSync(searchStrsFlLoc).toString().split("\n");	
	

	var LEN = searchStrs.length
	for (var i = 0; i < LEN; i++){
		var options = {
		  key: apikey,
		  langRestrict: 'en',
		  maxResults: 1,
		  country:'US',
		  q: ""
		};
    
		searchString = searchStrs[i] 
		options.q = searchString;
		console.log ( i + " " + searchString)
		books.volumes.list(options, (err, titles) => {
			if(err){
				
				console.error ("error in call to list " + err + err.toString());
			}else {		
				
				if (titles.data.totalItems == 0 || titles.status != 200){
					
					//Book not found
					
				}else{
					
					console.log (JSON.stringify(titles.data.items[0]))
			
				}
			}

		})
		
	}
		  
	
		
} catch (e) {
					
		console.error(e); 
}
	
 return res.status(200).send("OK");

}	

		
