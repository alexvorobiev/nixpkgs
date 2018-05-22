{ stdenv, buildPythonPackage, fetchPypi, pyyaml, openssh }:

buildPythonPackage rec {
  pname = "ClusterShell";
  version = "1.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bm0pq8w2rql9q9i2bhs865rqvb6zck3h3gkb1d0mh59arrr7p4m";
  };

  propagatedBuildInputs = [ pyyaml ];

  postPatch = ''
    sed -i 's|#ssh_path: /usr/bin/ssh$|ssh_path: ${openssh}/bin/ssh|1' conf/clush.conf
  '';
    
  meta = with stdenv.lib; {
    description = "Scalable Python framework for cluster administration";
    homepage = https://cea-hpc.github.io/clustershell;
    license = licenses.lgpl21;
    maintainers = maintainers.alexvorobiev;
  };
}
