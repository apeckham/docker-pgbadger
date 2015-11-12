(ns app.core
    (:gen-class)
    (:require [amazonica.aws.rds] [clojure.string]))

(def db (System/getenv "DB_INSTANCE_IDENTIFIER"))

(defn get-file
      [initial-opts]
      (loop [opts (assoc initial-opts :number-of-lines 1000 :marker 0)]
            (prn opts)
            (let [response (amazonica.aws.rds/download-dblog-file-portion opts)
                  basename (last (clojure.string/split (:log-file-name opts) #"/"))]
                 (spit basename (:log-file-data response) :append true)
                 (if (:additional-data-pending response)
                   (recur (assoc opts :marker (:marker response)))))))

(defn list-files
      []
      (:describe-dblog-files (amazonica.aws.rds/describe-dblog-files {:dbinstance-identifier db})))

(defn -main
      [& args]
      (for [file (list-files db)]
           (get-file {:log-file-name (:log-file-name file) :dbinstance-identifier db})))