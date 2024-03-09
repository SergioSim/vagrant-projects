#!/bin/python3

"""
Workaround for "CDPD-3038: Launching pyspark displays several HiveConf warning messages"
Copies a version of $HIVE_HOME/conf/hive-site.xml to $SPARK_HOME/conf/hive-site.xml
with some properties causing warning messages removed.
See: https://rb.gy/tt9gfz
"""

import os
import xml.etree.ElementTree as ET

HIVE_HOME = os.environ["HIVE_HOME"]
SPARK_HOME = os.environ["SPARK_HOME"]

PROPERTIES_TO_REMOVE = {
    "hive.metastore.wm.default.pool.size",
    "hive.llap.task.scheduler.preempt.independent",
    "hive.llap.output.format.arrow",
    "hive.tez.llap.min.reducer.per.executor",
    "hive.arrow.root.allocator.limit",
    "hive.vectorized.use.checked.expressions",
    "hive.tez.dynamic.semijoin.reduction.for.mapjoin",
    "hive.vectorized.complex.types.enabled",
    "hive.server2.wm.worker.threads",
    "hive.repl.partitions.dump.parallelism",
    "hive.metastore.uri.selection",
    "hive.strict.checks.no.partition.filter",
    "hive.tez.dynamic.semijoin.reduction.for.dpp.factor",
    "hive.stats.filter.in.min.ratio",
    "hive.metastore.client.cache.initial.capacity",
    "hive.stats.ndv.estimate.percent",
    "hive.server2.webui.cors.allowed.methods",
    "hive.optimize.joinreducededuplication",
    "hive.metastore.client.cache.enabled",
    "hive.stats.fetch.bitvector",
    "hive.disable.unsafe.external.table.operations",
    "hive.materializedview.rewriting.incremental",
    "hive.server2.materializedviews.registry.impl",
    "hive.metastore.event.db.notification.api.auth",
    "hive.exec.orc.delta.streaming.optimizations.enabled",
    "hive.stats.ndv.algo",
    "hive.spark.job.max.tasks",
    "hive.msck.repair.batch.max.retries",
    "hive.prewarm.spark.timeout",
    "hive.optimize.update.table.properties.from.serde.list",
    "hive.llap.plugin.client.num.threads",
    "hive.test.bucketcodec.version",
    "hive.query.reexecution.enabled",
    "hive.materializedview.rewriting.time.window",
    "hive.query.reexecution.stats.cache.batch.size",
    "hive.server2.webui.cors.allowed.headers",
    "hive.join.inner.residual",
    "hive.server2.active.passive.ha.enable",
    "hive.llap.io.trace.always.dump",
    "hive.query.reexecution.stats.persist.scope",
    "hive.mm.allow.originals",
    "hive.compactor.compact.insert.only",
    "hive.txn.xlock.iow",
    "hive.spark.rsc.conf.list",
    "hive.llap.cache.defaultfs.only.native.fileid",
    "hive.spark.optimize.shuffle.serde",
    "hive.testing.remove.logs",
    "hive.distcp.privileged.doAs",
    "hive.strict.checks.orderby.no.limit",
    "hive.metastore.client.cache.expiry.time",
    "hive.llap.io.allocator.defrag.headroom",
    "hive.notification.event.consumers",
    "hive.vectorized.input.format.supports.enabled",
    "hive.metastore.client.cache.max.capacity",
    "hive.repl.dumpdir.clean.freq",
    "hive.spark.use.ts.stats.for.mapjoin",
    "hive.repl.dump.include.acid.tables",
    "hive.server2.webui.use.pam",
    "hive.query.reexecution.max.count",
    "hive.llap.io.share.object.pools",
    "hive.optimize.update.table.properties.from.serde",
    "hive.service.metrics.codahale.reporter.classes",
    "hive.tez.session.events.print.summary",
    "hive.llap.io.vrb.queue.limit.base",
    "hive.mm.avoid.s3.globstatus",
    "hive.repl.replica.functions.root.dir",
    "hive.query.results.cache.max.entry.lifetime",
    "hive.server2.limit.connections.per.user",
    "hive.server2.thrift.http.compression.enabled",
    "hive.vectorized.execution.ptf.enabled",
    "hive.optimize.shared.work.extended",
    "hive.vectorized.row.identifier.enabled",
    "hive.query.reexecution.always.collect.operator.stats",
    "hive.repl.dumpdir.ttl",
    "hive.local.time.zone",
    "hive.server2.tez.wm.am.registry.timeout",
    "hive.server2.active.passive.ha.registry.namespace",
    "hive.create.as.insert.only",
    "hive.llap.mapjoin.memory.oversubscribe.factor",
    "hive.arrow.batch.size",
    "hive.notification.sequence.lock.retry.sleep.interval",
    "hive.repl.approx.max.load.tasks",
    "hive.query.results.cache.enabled",
    "hive.legacy.schema.for.all.serdes",
    "hive.tez.dag.status.check.interval",
    "hive.druid.bitmap.type",
    "hive.spark.dynamic.partition.pruning.map.join.only",
    "hive.llap.memory.oversubscription.max.executors.per.query",
    "hive.llap.io.trace.size",
    "hive.llap.plugin.rpc.num.handlers",
    "hive.server2.wm.allow.any.pool.via.jdbc",
    "hive.vectorized.groupby.complex.types.enabled",
    "hive.avro.timestamp.skip.conversion",
    "hive.query.results.cache.nontransactional.tables.enabled",
    "hive.stats.correlated.multi.key.joins",
    "hive.metastore.db.type",
    "hive.streaming.auto.flush.check.interval.size",
    "hive.zookeeper.connection.timeout",
    "hive.query.reexecution.strategies",
    "hive.server2.limit.connections.per.user.ipaddress",
    "hive.llap.mapjoin.memory.monitor.check.interval",
    "hive.optimize.shared.work",
    "hive.stats.estimate",
    "hive.llap.io.allocator.discard.method",
    "hive.tez.cartesian-product.enabled",
    "hive.notification.sequence.lock.max.retries",
    "hive.heap.memory.monitor.usage.threshold",
    "hive.privilege.synchronizer.interval",
    "hive.vectorized.adaptor.suppress.evaluate.exceptions",
    "hive.materializedview.rebuild.incremental",
    "hive.query.results.cache.max.entry.size",
    "hive.spark.stage.max.tasks",
    "hive.testing.short.logs",
    "hive.streaming.auto.flush.enabled",
    "hive.spark.explain.user",
    "hive.describe.partitionedtable.ignore.stats",
    "hive.server2.operation.log.cleanup.delay",
    "hive.repl.dump.metadata.only",
    "hive.optimize.countdistinct",
    "hive.auto.convert.join.shuffle.max.size",
    "hive.llap.plugin.acl",
    "hive.metastore.schema.info.class",
    "hive.server2.tez.queue.access.check",
    "hive.llap.external.splits.temp.table.storage.format",
    "hive.llap.io.row.wrapper.enabled",
    "hive.constraint.notnull.enforce",
    "hive.cli.print.escape.crlf",
    "hive.trigger.validation.interval",
    "hive.server2.webui.cors.allowed.origins",
    "hive.server2.limit.connections.per.ipaddress",
    "hive.llap.external.splits.order.by.force.single.split",
    "hive.metastore.client.cache.stats.enabled",
    "hive.notification.event.poll.interval",
    "hive.transactional.concatenate.noblock",
    "hive.materializedview.rewriting.strategy",
    "hive.vectorized.if.expr.mode",
    "hive.exim.test.mode",
    "hive.query.results.cache.directory",
    "hive.query.results.cache.wait.for.pending.results",
    "hive.remove.orderby.in.subquery",
    "hive.tez.bmj.use.subcache",
    "hive.llap.io.vrb.queue.limit.min",
    "hive.server2.wm.pool.metrics",
    "hive.repl.add.raw.reserved.namespace",
    "hive.resource.use.hdfs.location",
    "hive.stats.num.nulls.estimate.percent",
    "hive.llap.io.acid",
    "hive.llap.zk.sm.session.timeout",
    "hive.vectorized.ptf.max.memory.buffering.batch.count",
    "hive.llap.task.scheduler.am.registry",
    "hive.druid.overlord.address.default",
    "hive.optimize.remove.sq_count_check",
    "hive.server2.webui.enable.cors",
    "hive.vectorized.row.serde.inputformat.excludes",
    "hive.query.reexecution.stats.cache.size",
    "hive.combine.equivalent.work.optimization",
    "hive.lock.query.string.max.length",
    "hive.llap.io.track.cache.usage",
    "hive.use.orc.codec.pool",
    "hive.query.results.cache.max.size",
    "hive.repl.bootstrap.dump.open.txn.timeout",
}

tree = ET.parse(f"{HIVE_HOME}/conf/hive-site.xml")
root = tree.getroot()
for prop in list(root.iter('property')):
    name = prop.find("name").text
    if name in PROPERTIES_TO_REMOVE:
        print(f"Removing property = {name}")
        root.remove(prop)

tree.write(f"{SPARK_HOME}/conf/hive-site.xml")
