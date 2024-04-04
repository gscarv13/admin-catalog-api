# codeflix-admin-catalog
Catalog Administration - Codeflix - Ruby

## Category entity rules
- [x] `Name` is required
- [x] `Name` must have a maximum of 255 characters.
- [] When creating a new category, an identifier must be generated in the format (UUID).
- [] When creating a category, the fields id, description, and - isActive will not be mandatory.
- [] If the isActive property is not informed, it should default to true.
