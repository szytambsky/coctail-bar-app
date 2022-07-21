## coctail-bar-app
An Application that allows you to find your favourite drink/coctail based on the ingredient you are looking for. After tapping on the chosen one u will get details.

---

### Technologies

MVVM architecture with coordinators pattern to decouple concrete controllers.
Data source via rest api server: https://www.thecocktaildb.com/api.php

---

### Things to upgrade

- Make a class that builds URLRequest in more composable way (RequestType, path, parameters, queryItems).
- Handle returning empty response with some placeholder view.
- Async image downloading and caching.
- Improve UI components. 
- etc

