# workspace-full-vnc

## How to use for a Gitpod workspace

Put the following line in your `.gitpod.yml`:

If you do not have a `.gitpod.yml`, run `gp init` on your terminal to create one.

```yaml
image: gitpod/workspace-full-vnc
```

Lastly, [see it in action!](https://www.gitpod.io/docs/introduction/learn-gitpod/gitpod-yaml#see-it-in-action)

## Details

🖥 This image is mainly useful for GUI application development where you need a display server.

🔋 It's built on top of [workspace-full](../), it additionally contains:

- tigervnc server
- noVNC viewer
- google-chrome
- xfce4 desktop environment
- `gp-vncsession` script

Every time a Gitpod workspace is started, `gp-vncsession` script is executed from the workspace [`.bashrc`](./Dockerfile#L26) file.

This image could be used for:

- E2E testing requires a GUI based browser. (cypress, playwright, selenium and etc.)
- Some CLIs try to launch browser auth by default, it could help in that.
- GUI application development. Or just simply to run any Linux GUI application.

For more details, check the [Dockerfile](./Dockerfile)

## To be aware of

- There is no GPU acceleration. It's completely software rendered.
- Some complex 3D applications might crash.

## Learn more

- Docs:
    - https://www.gitpod.io/docs/introduction/languages/python#gui-applications-with-wxpython
- Blogs:
    - https://www.gitpod.io/blog/native-ui-with-vnc