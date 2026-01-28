git log --pretty=format:"%s" | grep -oP '(feat|fix|docs|style|chore|refactor|test)(?=:)' | sort | uniq -c
### [Components](https://www.conventionalcommits.org/en/v1.0.0/):
- `<type>`: Describes the kind of change being made.
  - `feat`: A new feature for the user or the application.
  - `fix`: A bug fix for the user or the application.
  - `docs`: Documentation changes.
  - `style`: Changes that do not affect the meaning of the code (e.g., formatting).
  - `refactor`: Code changes that neither fix a bug nor add a feature.
  - `test`: Adding missing tests or correcting existing tests.
  - `chore`: General maintenance or housekeeping tasks.

- `[optional scope]`: Describes the scope of the change (e.g., a module, file, component).

- `<description>`: A brief summary of the change.

- `[optional body]`: Additional details providing more context about the change.

- `[optional footer]`: Contains any additional information like issue references or breaking changes.
