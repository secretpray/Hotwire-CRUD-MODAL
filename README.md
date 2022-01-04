# Full CRUD on Hotwire

<details>
  <summary>Getting Started</summary>
  
  1) Bundle install:
  
  ```ruby
  bundle install
  ```
  2) Yarn install:
 
  ```ruby
  yarn install --check-files
  ```
  3) Prepare database (db:setup or db:prepare)
 
  ```ruby
  bin/rails db:setups
  ```
  
</details>

<details>
  <summary>Video Preview</summary>
  Hotwire CRUD simple

  https://user-images.githubusercontent.com/17977331/142139566-8944ec36-3649-4a59-963e-1df8956c2dfe.mp4

  Hotwire CRUD in Modal (with validation)

  https://user-images.githubusercontent.com/17977331/142774000-1455e1fa-f210-40df-a314-f2f2a1c6593b.mp4

  Devise User in Modal (edit profile only) and Tailwind dropdown 

  https://user-images.githubusercontent.com/17977331/144759682-3296d459-e2ee-4c77-a965-b6e3225384fc.mov

  Hotwire CRUD for Commets & Reply with broadcast and comments live counter

  https://user-images.githubusercontent.com/17977331/144759752-f09ea168-0158-4410-980a-74000ca0da01.mov

  Authorization Hotwire Commets & Reply (broadcast)

  https://user-images.githubusercontent.com/17977331/144826926-6c9c593d-4d51-4e4e-b49c-c18d7b5cdf50.mov

  Authorization Hotwire Posts (broadcast)

  https://user-images.githubusercontent.com/17977331/145093777-8c493f4d-9336-4c18-b1fa-540fa0a57f33.mp4

  Hotwire Comments info: comments count and author avatar (broadcast)

  https://user-images.githubusercontent.com/17977331/145165029-52a11c83-7411-4642-a343-5b82a24696b5.mov

  Hotwire 'Like' model with uniq validation. In real time (broadcast), information about the number of likes and whether the user has already voted is updated.

  https://user-images.githubusercontent.com/17977331/145777827-22698e2f-029b-4712-9877-57ac6f632dfe.mp4

  Hotwire online user status.

  https://user-images.githubusercontent.com/17977331/146153984-2170b5ca-6535-4de9-a199-439de09c58ff.mp4
  
  The maximum depth of nesting comments has been set (in Comment model -> 3).
  
  https://user-images.githubusercontent.com/17977331/146458915-1ea489b5-1419-4279-a802-5657140e3b33.mp4
  
  Added posts sorting with Hotwire. The selected sorting method is saved in Kredis.
  
  https://user-images.githubusercontent.com/17977331/147132281-937e9427-a1a6-447d-88fc-973495c62802.mp4
  
  Added live search on posts (with validation and debounce). Posts are sorted based on search results. Added tooltip.
  
  https://user-images.githubusercontent.com/17977331/147553151-0a5f9df0-077f-43c7-b75a-e1edd2f8c009.mov
  
  Added pagination with Pagy (Hotwire)
  
  https://user-images.githubusercontent.com/17977331/147630254-1c79de48-f292-4c9d-99f5-bf810d136baa.mov
  
  Added standard infinity scroll
  
  https://user-images.githubusercontent.com/17977331/148028203-4f05c9dc-614b-4f6b-a9ce-b4d22f5e0767.mp4
    
  Added asynchronous infinite scrolling after a certain delay (2.5 seconds)
  
  https://user-images.githubusercontent.com/17977331/148028250-dee27f72-0e46-4591-b848-51413573339c.mp4



 
</details>
<details>
  <summary>TODO:</summary>
  
  1. Filter search result
  
  2. Sanitize search input
  
  3. User history search in tooltip (5 result)

</details>
