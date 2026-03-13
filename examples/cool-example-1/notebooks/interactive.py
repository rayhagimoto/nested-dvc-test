import marimo

__generated_with = "0.20.4"
app = marimo.App(width="medium", auto_download=["ipynb", "html"])


@app.cell
def _():
    import marimo as mo
    import altair as alt
    import matplotlib.pyplot as plt
    import polars as pl
    import dvc.api

    return


@app.function
def exp_show(
    hide_workspace=False,
    hide_baseline=False,
    return_type: "dict" | "df" = "df",
    **dvc_kwargs,
):

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


@app.cell
def _():
    _exps_df = exp_show(
        hide_baseline=True, revs=["tagged-experiment"]
    )
    _exps_df
    return


@app.cell
def _():
    exps_df = exp_show(hide_baseline=True, revs=["tagged-experiment"])
    return (exps_df,)


@app.cell
def _(exps_df, pl, plt):
    def _make_plot(df: pl.DataFrame):
        "Plot avg test precision vs max number of features"

        df = df.sort("featurize.max_features")
        fig, ax = plt.subplots(figsize=(4, 3))
        ax.plot(df["featurize.max_features"], df["avg_prec.test"])
        ax.set_xlabel("featurize.max_features")
        ax.set_ylabel("avg_prec.test")

        return fig


    fig = _make_plot(exps_df)
    fig
    return


@app.cell
def _(exps_df):
    exps_df
    return


if __name__ == "__main__":
    app.run()
