# welcome-new-query
looking new query in your PR.

## What is this?

![image](https://user-images.githubusercontent.com/8022082/126127480-6294fa77-9e7a-4c9e-a0fb-c987dbfd9400.png)

If You use this action, You can check new query since last default branch merged.
It is very useful for your query perfomance check before production release.

## Architecture

1. Exporting query.log to db table.(enable-querylog action)
2. Run Your Test.
3. Check query.log to db table.(analysis action)
4. Save result to cache or S3

## Need to

You should save analysis result file to cache or ex:AWS S3.
This is because my implementation extracts the diff by comparing it with the result of the previous execution of the default branch.

## usage

[You had better check test actions in this repository](./.github/workflows/s3.yml)

```yml
steps:
  # copy last default branch result.
  - name: cache with default branch result
    uses: actions/cache@v2
    with:
      path: |
        ~/cache
      key: ${{ runner.os }}

  - run: bash -c "! test -e ~/cache/new-queries || cp ~/cache/new-queries /new-queries"

  # required
  - uses: pyama86/welcome-new-query@v2.0.0
    with:
      save_path: /new-queries
      db_host: db

  - name: Cache default branch result
    if: ${{ github.event_name == 'push' && github.ref == 'refs/heads/main' }}
    run: cp /new-queries ~/cache/
```

## parameter
- db_host
- db_user
- db_password(optional)

- aws_access_key_id(optional)
- aws_secret_access_key(optional)
- s3_bucket(optional)


