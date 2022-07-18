# osx-administration-scripts
Scripts for administering OSX servers in the command line


## grouped

This utility implements easy to remember wrappers for the complicated messes that are `dscl` and `dseditgroup`.

### Use:

The following commands will yield information about the available commands. Command names are self-explanatory.
- `source grouped.sh`
- `gedhelp`

## Functionality:
Currently supports:
- Listing all groups (and gids)
- Listing all users (and uids)
- Reading a single user's records
- Reading all user's records
- Creating/deleting users
- Creating/deleting groups
- Adding/removing users from groups
- Hiding/unhiding users
