from sklearn.datasets import load_iris
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
import pandas as pd
from pathlib import Path
import pickle
from sklearn.metrics import mean_squared_error
from dvclive import Live
import dvc.api

def get_params():
    params = dvc.api.params_show()
    print(params)
    return params

def prepare_data():
    # Get the Iris dataset
    X, y = load_iris(return_X_y=True, as_frame=True)

    # Save the data to disk
    X.to_csv("data/X.csv")
    y.to_csv("data/y.csv")

    X = X.to_numpy()
    y = y.to_numpy()
    return X, y

def _ensure_directory(dir):
    dir = Path(dir)
    dir.mkdir(exist_ok=True, parents=True)


def main():
    
    # Load params
    params = get_params()
    print(params)
    print("random_state = ", params["random_state"])
    random_state = int(params["random_state"])

    # Set up directories
    _ensure_directory("results/model")
    _ensure_directory("data")
    _ensure_directory("results/train")
    _ensure_directory("results/test")

    # Get the data
    X, y = prepare_data()

    X_train, X_test, y_train, y_test = train_test_split(X, y, train_size=0.8, random_state=random_state)

    # Train an OLS regression model
    model = LinearRegression()
    model.fit(X_train, y_train)
   

    # Save the model
    model_dir = "results/model"
    with open(f"{model_dir}/model.pkl", 'wb') as f:
        pickle.dump(model, f)

    # Save some metrics 
    y_pred = model.predict(X_train)
    mse_train = mean_squared_error(y_train, y_pred)

    y_pred = model.predict(X_test)
    mse_test = mean_squared_error(y_test, y_pred)

    with Live(dir="results", report="md") as live:
        # live.log_param("random_state", random_state)
        live.log_metric("train/mse", mse_train, plot=False)
        live.log_metric("test/mse", mse_test, plot=False)
        live.log_artifact(f"{model_dir}/model.pkl", type="model", name="ols-iris", desc="OLS Regression trained on Iris Dataset.")
        live.make_report()
        live.make_summary()

if __name__ == '__main__':
    main()


