```python
import marimo as mo
```


```python
import altair as alt
```


```python
import matplotlib.pyplot as plt
```


```python
def exp_show(
    hide_workspace=False,
    hide_baseline=False,
    return_type: "dict" | "df" = "df",
    **dvc_kwargs,
):
    import polars as pl
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
```


```python
_exps_df = exp_show(
    hide_baseline=True, revs=["dvc_exp/cool-example-1/seed-sweep"]
)
_exps_df
```




<div><style>
.dataframe > thead > tr,
.dataframe > tbody > tr {
  text-align: right;
  white-space: pre-wrap;
}
</style>
<small>shape: (2, 26)</small><table border="1" class="dataframe"><thead><tr><th>Experiment</th><th>rev</th><th>typ</th><th>Created</th><th>parent</th><th>State</th><th>Executor</th><th>avg_prec.train</th><th>avg_prec.test</th><th>roc_auc.train</th><th>roc_auc.test</th><th>prepare.split</th><th>prepare.seed</th><th>featurize.max_features</th><th>featurize.ngrams</th><th>train.seed</th><th>train.n_est</th><th>train.min_split</th><th>data/data.xml</th><th>data/features</th><th>data/prepared</th><th>model.pkl</th><th>src/evaluate.py</th><th>src/featurization.py</th><th>src/prepare.py</th><th>src/train.py</th></tr><tr><td>str</td><td>str</td><td>str</td><td>str</td><td>null</td><td>null</td><td>null</td><td>f64</td><td>f64</td><td>f64</td><td>f64</td><td>f64</td><td>f64</td><td>f64</td><td>f64</td><td>f64</td><td>f64</td><td>f64</td><td>str</td><td>str</td><td>str</td><td>str</td><td>str</td><td>str</td><td>str</td><td>str</td></tr></thead><tbody><tr><td>&quot;seed-sweep-1&quot;</td><td>&quot;a779b50&quot;</td><td>&quot;branch_commit&quot;</td><td>&quot;11:11 AM&quot;</td><td>null</td><td>null</td><td>null</td><td>0.973838</td><td>0.923202</td><td>0.986433</td><td>0.944476</td><td>0.2</td><td>2.0170428e7</td><td>200.0</td><td>2.0</td><td>1.0</td><td>50.0</td><td>0.01</td><td>&quot;22a1a2931c8370d3aeedd7183606fd…</td><td>&quot;f35d4cc2c552ac959ae602162b8543…</td><td>&quot;153aad06d376b6595932470e459ef4…</td><td>&quot;166bd3dca839d6f2f5e1baca152e6d…</td><td>&quot;a1a59f55636170fb56e0c6afd3e28f…</td><td>&quot;e22789fc9581cad11ef7a6fa3aa3f1…</td><td>&quot;f54d670ac8a4f63206781fc31d1f26…</td><td>&quot;324001573ed724e5ae092226fcf9ca…</td></tr><tr><td>&quot;seed-sweep-2&quot;</td><td>&quot;1eb6956&quot;</td><td>&quot;branch_base&quot;</td><td>&quot;11:11 AM&quot;</td><td>null</td><td>null</td><td>null</td><td>0.974357</td><td>0.92739</td><td>0.986618</td><td>0.947757</td><td>0.2</td><td>2.0170428e7</td><td>200.0</td><td>2.0</td><td>2.0</td><td>50.0</td><td>0.01</td><td>&quot;22a1a2931c8370d3aeedd7183606fd…</td><td>&quot;f35d4cc2c552ac959ae602162b8543…</td><td>&quot;153aad06d376b6595932470e459ef4…</td><td>&quot;5aeede18ac1b624af04636a274dd60…</td><td>&quot;a1a59f55636170fb56e0c6afd3e28f…</td><td>&quot;e22789fc9581cad11ef7a6fa3aa3f1…</td><td>&quot;f54d670ac8a4f63206781fc31d1f26…</td><td>&quot;324001573ed724e5ae092226fcf9ca…</td></tr></tbody></table></div>




```python
exps_df = exp_show(hide_baseline=True)
```


```python
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
```




    
![png](figs/interactive_6_0.png)
    




    
![png](figs/interactive_6_1.png)
    



```python
exps_df
```




<div><style>
.dataframe > thead > tr,
.dataframe > tbody > tr {
  text-align: right;
  white-space: pre-wrap;
}
</style>
<small>shape: (5, 26)</small><table border="1" class="dataframe"><thead><tr><th>Experiment</th><th>rev</th><th>typ</th><th>Created</th><th>parent</th><th>State</th><th>Executor</th><th>avg_prec.train</th><th>avg_prec.test</th><th>roc_auc.train</th><th>roc_auc.test</th><th>prepare.split</th><th>prepare.seed</th><th>featurize.max_features</th><th>featurize.ngrams</th><th>train.seed</th><th>train.n_est</th><th>train.min_split</th><th>data/data.xml</th><th>data/features</th><th>data/prepared</th><th>model.pkl</th><th>src/evaluate.py</th><th>src/featurization.py</th><th>src/prepare.py</th><th>src/train.py</th></tr><tr><td>str</td><td>str</td><td>str</td><td>str</td><td>null</td><td>str</td><td>str</td><td>f64</td><td>f64</td><td>f64</td><td>f64</td><td>f64</td><td>f64</td><td>f64</td><td>f64</td><td>f64</td><td>f64</td><td>f64</td><td>str</td><td>str</td><td>str</td><td>str</td><td>str</td><td>str</td><td>str</td><td>str</td></tr></thead><tbody><tr><td>&quot;max-features-sweep-1&quot;</td><td>&quot;18f0e96&quot;</td><td>&quot;branch_commit&quot;</td><td>&quot;11:40 AM&quot;</td><td>null</td><td>&quot;Success&quot;</td><td>&quot;Dvc-task&quot;</td><td>0.509346</td><td>0.499269</td><td>0.727099</td><td>0.72494</td><td>0.2</td><td>2.0170428e7</td><td>2.0</td><td>2.0</td><td>2.0170428e7</td><td>50.0</td><td>0.01</td><td>&quot;22a1a2931c8370d3aeedd7183606fd…</td><td>&quot;16f507947bd34321b58c1fffd2dd83…</td><td>&quot;153aad06d376b6595932470e459ef4…</td><td>&quot;b4379374296de283459217a19dcfa4…</td><td>&quot;a1a59f55636170fb56e0c6afd3e28f…</td><td>&quot;e22789fc9581cad11ef7a6fa3aa3f1…</td><td>&quot;f54d670ac8a4f63206781fc31d1f26…</td><td>&quot;324001573ed724e5ae092226fcf9ca…</td></tr><tr><td>&quot;max-features-sweep-4&quot;</td><td>&quot;b7da141&quot;</td><td>&quot;branch_commit&quot;</td><td>&quot;11:40 AM&quot;</td><td>null</td><td>&quot;Success&quot;</td><td>&quot;Dvc-task&quot;</td><td>0.826579</td><td>0.759325</td><td>0.887925</td><td>0.826432</td><td>0.2</td><td>2.0170428e7</td><td>16.0</td><td>2.0</td><td>2.0170428e7</td><td>50.0</td><td>0.01</td><td>&quot;22a1a2931c8370d3aeedd7183606fd…</td><td>&quot;feb1dfa5aec2bab364e000448c2ddf…</td><td>&quot;153aad06d376b6595932470e459ef4…</td><td>&quot;e4e019dec0ef1a3650b06348db1ae4…</td><td>&quot;a1a59f55636170fb56e0c6afd3e28f…</td><td>&quot;e22789fc9581cad11ef7a6fa3aa3f1…</td><td>&quot;f54d670ac8a4f63206781fc31d1f26…</td><td>&quot;324001573ed724e5ae092226fcf9ca…</td></tr><tr><td>&quot;max-features-sweep-3&quot;</td><td>&quot;984b2a9&quot;</td><td>&quot;branch_commit&quot;</td><td>&quot;11:40 AM&quot;</td><td>null</td><td>&quot;Success&quot;</td><td>&quot;Dvc-task&quot;</td><td>0.751372</td><td>0.727249</td><td>0.823053</td><td>0.810283</td><td>0.2</td><td>2.0170428e7</td><td>8.0</td><td>2.0</td><td>2.0170428e7</td><td>50.0</td><td>0.01</td><td>&quot;22a1a2931c8370d3aeedd7183606fd…</td><td>&quot;ed5960fa4bcdfbe0b24f97ca989cf8…</td><td>&quot;153aad06d376b6595932470e459ef4…</td><td>&quot;5de7365bf745ec1702b3a38a4a9afc…</td><td>&quot;a1a59f55636170fb56e0c6afd3e28f…</td><td>&quot;e22789fc9581cad11ef7a6fa3aa3f1…</td><td>&quot;f54d670ac8a4f63206781fc31d1f26…</td><td>&quot;324001573ed724e5ae092226fcf9ca…</td></tr><tr><td>&quot;max-features-sweep-2&quot;</td><td>&quot;8526ccd&quot;</td><td>&quot;branch_commit&quot;</td><td>&quot;11:40 AM&quot;</td><td>null</td><td>&quot;Success&quot;</td><td>&quot;Dvc-task&quot;</td><td>0.691321</td><td>0.680199</td><td>0.783392</td><td>0.781675</td><td>0.2</td><td>2.0170428e7</td><td>4.0</td><td>2.0</td><td>2.0170428e7</td><td>50.0</td><td>0.01</td><td>&quot;22a1a2931c8370d3aeedd7183606fd…</td><td>&quot;ec848350825d44293cda477932e187…</td><td>&quot;153aad06d376b6595932470e459ef4…</td><td>&quot;2c436ec304f65896df326c6459f845…</td><td>&quot;a1a59f55636170fb56e0c6afd3e28f…</td><td>&quot;e22789fc9581cad11ef7a6fa3aa3f1…</td><td>&quot;f54d670ac8a4f63206781fc31d1f26…</td><td>&quot;324001573ed724e5ae092226fcf9ca…</td></tr><tr><td>&quot;max-features-sweep-5&quot;</td><td>&quot;6bf8b7f&quot;</td><td>&quot;branch_base&quot;</td><td>&quot;11:40 AM&quot;</td><td>null</td><td>&quot;Success&quot;</td><td>&quot;Dvc-task&quot;</td><td>0.874616</td><td>0.788185</td><td>0.931143</td><td>0.865073</td><td>0.2</td><td>2.0170428e7</td><td>32.0</td><td>2.0</td><td>2.0170428e7</td><td>50.0</td><td>0.01</td><td>&quot;22a1a2931c8370d3aeedd7183606fd…</td><td>&quot;4e925b8acc2804e8def55056ed1408…</td><td>&quot;153aad06d376b6595932470e459ef4…</td><td>&quot;eab02fbc332882a8a703c8c7a5bee8…</td><td>&quot;a1a59f55636170fb56e0c6afd3e28f…</td><td>&quot;e22789fc9581cad11ef7a6fa3aa3f1…</td><td>&quot;f54d670ac8a4f63206781fc31d1f26…</td><td>&quot;324001573ed724e5ae092226fcf9ca…</td></tr></tbody></table></div>


