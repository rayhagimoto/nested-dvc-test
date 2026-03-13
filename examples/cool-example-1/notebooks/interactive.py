import marimo

__generated_with = "0.20.4"
app = marimo.App(width="medium", auto_download=["ipynb", "html"])


@app.cell
def _():
    import marimo as mo

    return


@app.cell
def _():
    import dvc.api

    return


@app.cell
def _():
    import polars as pl

    return (pl,)


@app.cell
def _(Literal, pl):
    def exp_show(
        hide_workspace=False,
        hide_baseline=False,
        return_type: Literal["dict", "df"] = "df",
        **dvc_kwargs,
    ):
        import dvc.api

        exps_dict = dvc.api.exp_show(**dvc_kwargs)
        df = pl.DataFrame(exps_dict)

        if hide_workspace:
            df = df.filter(pl.col("rev") != "workspace")

        if hide_baseline:
            # this also hides workspace since 'workspace' commit always has 'typ'==baseline
            df = df.filter(pl.col("typ") != "baseline")

        if return_type == "dict":
            df = df.to_dict()

        return df

    return (exp_show,)


@app.cell
def _(exp_show):
    exps_df = exp_show(
        hide_baseline=True, revs=["dvc_exp/cool-example-1/seed-sweep"]
    )
    exps_df
    return


@app.cell
def _():
    import altair as alt

    return


app._unparsable_cell(
    r"""
    def _plot_
    """,
    name="_"
)


if __name__ == "__main__":
    app.run()
